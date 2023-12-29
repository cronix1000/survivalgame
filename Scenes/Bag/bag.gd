extends CharacterBody2D
class_name Bag

@export var inventory : Inventory
@onready var inventoryUI = $CanvasLayer/slot_container_generic
func _ready():
	inventoryUI.display_item_slots(inventory.cols, inventory.rows)
	inventory.connect("items_changed", Callable(self, "if_empty_destroy"))
	emit_signal("ready")

func interact(s):
	inventoryUI.visible = true

func cancel_interact():
	inventoryUI.visible = false
	
func if_empty_destroy(s):
	var count = 0
	for value in inventory.items:
		if value != null:
			count += 1
	if count == 0:
		queue_free()
		
			
