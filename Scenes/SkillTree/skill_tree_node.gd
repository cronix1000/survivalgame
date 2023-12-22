@tool
extends TextureButton

signal on_learned(node)
signal on_unlocked()

@onready var player = get_tree().get_first_node_in_group("player")
@export var ability : ability_node
@export var previous_nodes_connected : Array[TextureButton] = []
@export var unlockable : bool = false : set = set_unlocked
@export var learned : bool
@export var tree_node_line : PackedScene

# REQUIRED STATS
@export var health : int = 5
@export var stamina : int
@export var strength : int

func _ready():
	refresh_lines()
	connect_nodes()

func connect_nodes():
	for previous_node in previous_nodes_connected:
		previous_node.connect("on_learned" ,Callable(self, "_on_on_learned"))

func _on_pressed():
	if(!check_if_can_take()):
		return
	if(learned):
		return
	learned = true
	emit_signal("on_learned", self)
	print("Skill_Node %s learned" % name)
	

func UnlockFurtherNodes():
	print("asd")
func learn_skill():
	player.load_ability(ability.ability_name)

func check_if_can_take() -> bool:
	if(unlockable):
		if(player.can_unlock(health, stamina, strength)):
			return true
	return false
		
func check_unlocked():
	var unlocked = true	
	for previus_node in previous_nodes_connected:
		unlocked = unlocked && previus_node.learned
	set_unlocked(unlocked)

func set_unlocked(_unlocked):
	unlockable = _unlocked
	print("Skill_Node %s unlocked" % ability.ability_name)	
	print(unlockable)
	
	
var lines
	
func refresh_lines(): #this sets the line2d to be connected with the previous_nodesff
	if not lines:
		lines = {}
	if Engine.is_editor_hint(): # deletes old lines if we are in the editor
		for node in lines:
			var line = lines[node]
			line.queue_free()
		lines = {}
	
	for previous_node in previous_nodes_connected:
		refresh_line(previous_node)


#for the line to properly show behind the line2d the lowest nodes have to be the lowest in the tree
func refresh_line(previous_node):
	if not previous_node:
		return
	var line = lines.get(previous_node)
	if not line:
		line = tree_node_line.instantiate()
		
		line.add_point(get_rect().size / 2)
		#lines[previous_node] = line
		add_child(line)
	var target_pos = previous_node.get_global_rect().position
	line.add_point(target_pos)
	# var target_pos = previous_node.global_position
	var line_point = target_pos - get_global_rect().position
	line.add_point(line_point)
	var points = line.points
	
	if points.size() > 1:
		points.remove_at(1)
	points.append(line_point)
	line.points = points


func _on_on_learned(node):
	check_unlocked()
	print(ability.ability_name + "Signal called to")


func _on_on_unlocked():
	pass # Replace with function body.
