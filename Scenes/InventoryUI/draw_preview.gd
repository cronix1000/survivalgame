extends Control


var dragged_item = {} :
	set(val):
		set_dragged_item(val)
		
@onready var item_icon = $item_icon
@onready var item_quantity = $item_quantity
		
func _process(delta):
	if dragged_item:
		position = get_global_mouse_position()		

func set_dragged_item(item):
	dragged_item = item
	if(dragged_item):
		item_icon.texture = load("res://assets/items/%s" % dragged_item.icon)
		item_quantity.text = str(dragged_item.quantity) if dragged_item.stackable else ""
	else:
		item_icon.texture = null
		item_quantity.text = ""
