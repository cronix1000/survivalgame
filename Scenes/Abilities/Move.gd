extends Node2D


func move(s , movement_speed : int , mov_vector2 : Vector2 ):
	s.velocity = mov_vector2 * movement_speed
	s.move_and_slide()
	


