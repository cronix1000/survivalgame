extends Entity

@onready var move = load_ability("move")
@onready var basic_attack = load_ability("basic_attack")
@onready var interact_timer : Timer = $InteractTimer
@onready var inventoryUI = $inventory_holder/CanvasLayer/slot_container_generic
@onready var inventory : Inventory = $inventory
signal has_moved
var can_interact = true
# Called when the node enters the scene tree for the first time.
func _ready():
	player.play("idle")
	var item =generate_item()
	PlayerData.inventory = inventory
	inventory.items[0] = preload("res://Scenes/Items/basic_sword.tres")
	inventory.items[1] = preload("res://Scenes/Items/basic_bow.tres")
	inventory.items[3] = preload("res://Scenes/Items/crown.tres")
	inventoryUI.display_item_slots(inventory.cols, inventory.rows)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	check_input()
	movement()
func get_aim_position():
	return get_global_mouse_position()
func check_input():
	if(Input.is_action_pressed("Attack")): basic_attack.basic_attack(self, "basic_sword", 1)
	if(can_interact):
		if(Input.is_action_pressed("Interact")):
			var collision = get_last_slide_collision()
			if(collision && collision.get_collider()):
				var collider = collision.get_collider()
				if(collider.is_in_group("interact")):
					collider.interact(self)
					if(!self.is_connected("has_moved", Callable(collider, "cancel_interact"))):
						connect("has_moved", Callable(collider, "cancel_interact"))
					can_interact = false
					interact_timer.start()
			

func generate_item():
	var item = GameMaster.get_item_by_key("sword")

func movement():
	var x_move = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y_move = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	var move_now = Vector2(x_move, y_move)
	move.move(self,movement_speed,move_now)
	if(x_move == 1):
		character_sprite.flip_h = true
	if(x_move == -1):
		character_sprite.flip_h = false
	
	if(velocity != Vector2(0,0)):
		emit_signal("has_moved")

	
func can_unlock(health : int, stamina : int, strength : int) -> bool:
	return true


func _on_interact_timer_timeout():
	can_interact = true


func _on_has_died():
	print("had died")
