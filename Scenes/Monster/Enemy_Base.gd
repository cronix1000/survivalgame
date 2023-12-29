extends  Entity
class_name EnemyBase


var loot_bag = preload("res://Scenes/Bag/bag.tscn")
@export var drop_table : DropTable 

func _on_has_died():
	var bag : Bag = loot_bag.instantiate()
	var items : Array[Item] = get_list_of_items()
	if(items != null):
		var index = 0
		bag.inventory.force_ready()
		#print(str(drop_table.drop_table[0].key))
		for item in items:
			bag.inventory.set_item(index,item)
			index += 1
	bag.position = global_position + Vector2(10,0)
	bag.name = "loot_bag"
	get_tree().get_first_node_in_group("main").add_child(bag)
	queue_free()

func get_list_of_items() ->Array[Item]:
	var items : Array[Item] = []
	var index = 0
	#print(str(drop_table.drop_table[0].key))
	for item in drop_table.drop_table:
		var random_float = randf()
		if random_float < item:
			items.append(null)
			items[index] = drop_table.drop_table[item]
			index += 1
	return items
			
		

