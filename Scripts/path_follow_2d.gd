extends PathFollow2D

@export var speed: float = 300.0

func _ready() -> void:
	rotates = false

func _process(delta: float) -> void:
	progress += speed * delta
