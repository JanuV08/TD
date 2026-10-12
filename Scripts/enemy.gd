extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var last_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	last_position = global_position

func _process(_delta: float) -> void:
	# Safety check before updating
	if not is_instance_valid(animated_sprite):
		return

	var movement_vector: Vector2 = global_position - last_position
	update_animation(movement_vector)
	last_position = global_position

func update_animation(dir: Vector2) -> void:
	# Check if node was freed mid-frame
	if not is_instance_valid(animated_sprite):
		return

	# If stationary, stop or pause animation
	if dir.length() < 0.1:
		animated_sprite.stop()
		return

	# Determine horizontal vs vertical movement
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("walk_side")
		animated_sprite.flip_h = dir.x < 0
	else:
		animated_sprite.flip_h = false
		if dir.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")
