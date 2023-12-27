extends GridContainer
class_name slot_container_generic

@export var ItemSlot : PackedScene
@export var Inventory : Inventory

var slots

func _ready():
	display_item_slots(Inventory.cols, Inventory.rows)
	await "process_frame"
	#position = (get_viewport_rect().size - get_rect().size) /2
	hide()


func display_item_slots(cols,rows):
	await Inventory.ready
	columns = cols
	slots = cols* rows
	print(Inventory.items[0])
	for index in range(slots):
		var item_slot = ItemSlot.instantiate()
		item_slot.name = "%s" % index
		add_child(item_slot)
		item_slot.display_item(Inventory.items[index])
	Inventory.connect("items_changed", Callable(self, "_on_inventory_items_changed"))
	
func _on_inventory_items_changed(indexes):
	for index in indexes:
		if index < slots:
			var item_slot = get_child(index)
			item_slot.display_item(Inventory.items[index])
		
