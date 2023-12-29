extends CharacterBody2D

@onready var inventory : Inventory = $inventory
@onready var inventoryUI = $CanvasLayer/slot_container_generic
func _ready():
	var item = preload("res://Scenes/Items/crown.tres")
	inventory.set_item(0, item)
	inventoryUI.display_item_slots(inventory.cols, inventory.rows)

func interact(s):
	inventoryUI.visible = true

func cancel_interact():
	inventoryUI.visible = false
	

