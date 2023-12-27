extends Node



var home_scene = preload("res://Scenes/World/home.tscn").instantiate()

var items

func _ready():
	items = read_from_JSON("res://scripts/items_json.json")
	for key in items.keys():
		items[key]["key"] = key


func get_item_by_key(key):
	if items and items.has(key):
		return items[key].duplicate(true)

func read_from_JSON(path):
		if(FileAccess.file_exists(path)):
			var file = FileAccess.open(path, FileAccess.READ)
			
			var string = file.get_as_text()
			var json = JSON.new()
			var error = json.parse(string)
			var data = json.data
			file.close()
			return data
		else:
			printerr("Invalid Path")

func return_to_home():
	pass

func generate_and_move_to_dungeon():
	pass
