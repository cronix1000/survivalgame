extends Node
class_name basic_attack

var cooldown: int = 1
@onready var timer: Timer = $Timer
var bullets: int =  0

func basic_attack(s, weapon_name: String, _cooldown: float):
	if(timer.is_stopped()):
		timer.start()
	if(bullets > 0):
		timer.wait_time = _cooldown
		var f : PackedScene = load("res://Scenes/Abilities/BasicAttacks/" + weapon_name + "_basic_attack.tscn")
		var f_node : Node = f.instantiate()
		f_node.controller = s
		f_node.position = s.global_position
		f_node.add_collision_exception_with(s)
		
		get_node("/root").add_child(f_node)
		bullets -= 1



func _on_timer_timeout():
		bullets+=1
