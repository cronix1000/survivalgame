extends CharacterBody2D

@export var movement_speed : int = 30.0
@onready var player : AnimationPlayer = $AnimationPlayer
@onready var character_sprite : Sprite2D = $CharacterSprite
@onready var move = load_ability("move")
# Called when the node enters the scene tree for the first time.
func _ready():
	player.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	movement()

func movement():
	var x_move = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y_move = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	var move_now = Vector2(x_move, y_move)
	move.move(self,movement_speed,move_now)
	if(x_move == 1):
		character_sprite.flip_h = true
	if(x_move == -1):
		character_sprite.flip_h = false

func load_ability(ability_name : String):
	var scene = load("res://Scenes/Abilities/" + ability_name + ".tscn")
	var scene_node = scene.instantiate()
	add_child(scene_node)
	return scene_node;
