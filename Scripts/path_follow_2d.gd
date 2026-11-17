extends PathFollow2D

@export var speed: float = 300.0

func _ready() -> void:
	rotates = false
	if get_child_count() > 0 and "speed" in get_child(0):
		speed = get_child(0).speed

func _process(delta: float) -> void:
	progress += speed * delta
