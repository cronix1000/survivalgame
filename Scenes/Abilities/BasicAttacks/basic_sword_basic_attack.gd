extends CharacterBody2D

@onready var aim_pos
@onready var self_pos

var speed = 200
var controller = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self_pos = self.global_position
	aim_pos = controller.get_aim_position()
	velocity = self_pos.direction_to(aim_pos) * speed
	
	await get_tree().create_timer(2).timeout
	queue_free()
	#Explote etc...


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	var collision = get_last_slide_collision()
	if(collision && collision.get_collider()):
		var collider = collision.get_collider()
		queue_free()
		#if(collider.is_in_group("health")):
		#	collider.health
			
