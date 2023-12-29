extends Area2D

var hurtTimer
var canHurt = true 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hurtTimer += delta
	if(hurtTimer > 3)


func _on_area_entered(area):
	if(area.is_in_group("entity")):
		pass
