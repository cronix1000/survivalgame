@tool
extends CharacterBody2D
class_name Entity


@export var movement_speed : int = 30.0
@export var hp_total : int = 0
var hp : int = hp_total : set = set_hp
@export var defence : int = 0


@onready var player : AnimationPlayer = $AnimationPlayer
@onready var character_sprite : Sprite2D = $CharacterSprite
@onready var hurt_box = $Hurt_Box

signal hp_changed(new_hp)
signal hp_max_changed(new_total_hp)
signal has_died

func load_ability(ability_name : String):
	var scene = load("res://Scenes/Abilities/" + ability_name + ".tscn")
	var scene_node = scene.instantiate()
	add_child(scene_node)
	return scene_node;

func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_total)
		emit_signal("hp_changed", hp)
		if(hp == 0):
			emit_signal("has_died")
	
func set_hp_total(value):
	if value != hp_total:
		hp_total = max(0, value)
		emit_signal("hp_max_changed", hp_total)
		self.hp = hp

func _on_hurt_box_area_entered(hitbox):
	var base_damage = hitbox.damage
	self.hp -= base_damage
	print(hitbox.get_parent().name + "'s hitbox touched " + name + "'s hurtbox and dealth " + str(base_damage) + " damage")
	# switch to actual recieve damage funtion
