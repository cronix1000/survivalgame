extends TextureRect

@export var gear_slot : String
#@onready var item_icon = $item_icon
@onready var item_quantity = $item_quantity

func display_item(item):
	if item:
		texture = load("res://assets/items/%s" % item.icon)
		item_quantity.text = str(item.quantity) if item.stackable else ""
	else:
		texture = null
		item_quantity.text = ""
			
			
func _get_drag_data(at_position):
	var equipment_slot = gear_slot
	if(PlayerData.equipment_data[equipment_slot] != null):
		var data = {}
		data["item"] = PlayerData.equipment_data[equipment_slot]
		data["origin_image"] = texture
		data["origin_node"] = self
		data["origin_panel"] = "gear"
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.set_size(Vector2(16,16))
		set_drag_preview(drag_texture)
		return data
	
func _can_drop_data(at_position, data):
	var target_equipment_slot = gear_slot
	if(target_equipment_slot == data["item"].equipment_slot):
		# target place is empty
		if(PlayerData.equipment_data[target_equipment_slot] == null):
			data["target_texture"] = null
			data["target_item"] = null 
		# target has an item we need to swap them
		else: 
			data["target_texture"] = texture
			data["target_item"] = PlayerData.equipment_data[target_equipment_slot]
		return true
	else:
		return false
			
func _drop_data(at_position, data):
	var target_equipment_slot = gear_slot
	var origin_slot 
	if(data["origin_panel"] == "inventory"):
		origin_slot = data["origin_node"].get_name().to_int()
	elif(data["origin_panel"] == "gear"):
		origin_slot = data["origin_node"].gear_slot
		
	
	# if the item originates from the inventory
	if data["origin_panel"] == "inventory":
		# if we need to swap the item if not it will set as null
		PlayerData.inventory.set_item(origin_slot, data["target_item"])
		PlayerData.equipment_data[target_equipment_slot] =  data["target_item"]
	elif(data["origin_panel"] == "gear"):
		PlayerData.equipment_data[origin_slot] =  data["item"]
	
	# update the texture of the origin
	if(data["origin_panel"] == "gear" and data["target_item"] == null):
		var default_texture = load("res://assets/UI_Elements/" + origin_slot + "_default_icon.png")
		data["origin_node"].texture = default_texture
		#data["origin_node"].display_item(data["target_item"])
	else:
		data["origin_node"].display_item(data["target_item"])
	
	PlayerData.equipment_data[target_equipment_slot] = data["item"]
	display_item(data["item"])
