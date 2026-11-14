extends Area2D

var target_pos: Vector2
var speed: float = 600.0

func _process(delta: float) -> void:
	global_position = global_position.move_toward(target_pos, speed * delta)
	
	if global_position.distance_to(target_pos) < 5.0:
		queue_free()
