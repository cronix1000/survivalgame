extends Node2D


@onready var inventory_menu = $CanvasLayer/slot_container_generic

func _unhandled_input(event):
	if(event.is_action_pressed("ui")):
		inventory_menu.visible = !inventory_menu.visible
