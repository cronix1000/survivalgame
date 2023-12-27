extends slot_container_generic

func _ready():
	display_item_slots(Inventory.cols, Inventory.rows)
	await "process_frame"
	position = (get_viewport_rect().size - get_rect().size) /2
	hide()
