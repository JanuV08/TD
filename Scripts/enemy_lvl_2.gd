class_name EnemyLVL2
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var last_position: Vector2 = Vector2.ZERO

@export var damage_to_base : int = 10
@export var enemy_type: String = "lvl2"

var current_hp: int
@export var max_hp: int = 10
@onready var health_bar: ProgressBar = $CharacterBody2D/ProgressBar

func _ready() -> void:
	last_position = global_position
	last_position = global_position
	current_hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = current_hp 

func _process(_delta: float) -> void:
	if not is_instance_valid(animated_sprite):
		return

	var movement_vector: Vector2 = global_position - last_position
	update_animation(movement_vector)
	last_position = global_position

func update_animation(dir: Vector2) -> void:
	if not is_instance_valid(animated_sprite) or animated_sprite.sprite_frames == null:
		return

	if dir.length() < 0.1:
		animated_sprite.stop()
		return

	var frames: SpriteFrames = animated_sprite.sprite_frames

	if abs(dir.x) > abs(dir.y):
		if frames.has_animation("walk_side"):
			animated_sprite.play("walk_side")
		animated_sprite.flip_h = dir.x < 0
	else:
		animated_sprite.flip_h = false
		if dir.y > 0 and frames.has_animation("walk_down"):
			animated_sprite.play("walk_down")
		elif dir.y <= 0 and frames.has_animation("walk_up"):
			animated_sprite.play("walk_up")
