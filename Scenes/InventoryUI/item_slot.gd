extends ColorRect
class_name item_slot


@onready var item_icon = $item_icon
@onready var item_quantity = $item_quantity
var inventory : Inventory
var local_item

func _ready():
	inventory = get_parent().Inventory

func display_item(item):
	if item:
		item_icon.texture = load("res://assets/items/%s" % item.icon)
		item_quantity.text = str(item.quantity) if item.stackable else ""
		#local_item = item
	else:
		item_icon.texture = null
		item_quantity.text = ""

func _get_drag_data(at_position):
	var inv_slot = name
	var inv_slot_number = inv_slot.to_int()
	if(inventory.items[inv_slot_number] != null):
		var data = {}
		data["item"] = inventory.items[inv_slot_number]
		data["origin_image"] = item_icon.texture
		data["origin_node"] = self
		data["origin_panel"] = "inventory"
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = item_icon.texture
		drag_texture.set_size(Vector2(16,16))
		var preview = Control.new()
		drag_texture.set_position(-0.5 * drag_texture.get_rect().size)
		preview.add_child(drag_texture)
		set_drag_preview(preview)
		return data
	
func _can_drop_data(at_position, data):
	var inv_slot = name
	var inv_slot_number = inv_slot.to_int()
	data["target_slot"] = inv_slot_number
	# Item slot is empty
	if(inventory.items[inv_slot_number]) == null:
		data["target_texture"] = null
		data["target_item"] = null
		return true 
	#swap items
	else:
		data["target_item"] = inventory.items[inv_slot_number]
		data["target_texture"] = item_icon.texture
		if(data["origin_panel"] == "gear"):
			var target_inventory_slot = inventory.items[inv_slot_number].equipment_slot
			# if the item comes from the equipment and we try to replace it with an inventory item only 
			# swap if they are the same type i.e swapping sword for dagger = true or swapping sword for helmet = false
			if(target_inventory_slot == data["item"].equipment_slot):
				return true
			else:
				return false
		else: # data comes from Inventory
			return true

func _drop_data(at_position, data):
	var target_inventory_slot = name.to_int()
	var origin_slot
	if(data["origin_panel"] == "inventory"):
		origin_slot = data["origin_node"].get_name().to_int()
	elif(data["origin_panel"] == "gear"):
		origin_slot = data["origin_node"].gear_slot
	elif(data["origin_panel"] == "loot"):
		origin_slot = data["origin_node"].get_name().to_int()
		
	
	# if the item originates from the inventory
	if data["origin_panel"] == "inventory":
		# if we need to swap the item if not it will set as null
		inventory.set_item(origin_slot, data["target_item"])
	elif(data["origin_panel"] == "gear"):
		PlayerData.equipment_data[origin_slot] =  data["target_item"]
		inventory.set_item(target_inventory_slot, data["target_item"])
	elif(data["origin_panel"] == "loot"):
		data["origin_node"].inventory.set_item(origin_slot, data["target_item"])
		
	
	# update the texture of the origin
	if(data["origin_panel"] == "gear" and data["target_item"] == null):
		var default_texture = load("res://assets/UI_Elements/" + origin_slot + "_default_icon.png")
		data["origin_node"].texture = default_texture
	else:
		data["origin_node"].display_item(data["target_item"])
	
	inventory.items[target_inventory_slot] = data["item"]
	#print(PlayerData.equipment_data[target_equipment_slot].icon)
	display_item(data["item"])
