class_name Enemy
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var health_bar: ProgressBar = $CharacterBody2D/ProgressBar
@onready var death_particles: CPUParticles2D = $CharacterBody2D/DeathParticles

var last_position: Vector2 = Vector2.ZERO
var is_dead: bool = false

@export var damage_to_base : int = 5
@export var enemy_type: String = "lvl1"

@export var max_hp: int = 20
var current_hp: int

func _ready() -> void:
	last_position = global_position
	current_hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = current_hp

func _process(_delta: float) -> void:
	if is_dead or not is_instance_valid(animated_sprite):
		return
	
	health_bar.value = current_hp
	
	var movement_vector: Vector2 = global_position - last_position
	update_animation(movement_vector)
	last_position = global_position

func take_damage(amount: int) -> void:
	if is_dead:
		return
		
	current_hp -= amount
	print("HP nepřítele ", name, " kleslo na: ", current_hp)
	
	if is_instance_valid(health_bar):
		health_bar.value = current_hp
		
	if current_hp <= 0:
		die()
		return
	
	modulate = Color(3.0, 3.0, 3.0)
	get_tree().create_timer(0.1).timeout.connect(func():
		if is_instance_valid(self) and not is_dead:
			modulate = Color(1, 1, 1)
	)

func die() -> void:
	is_dead = true
	Global.enemyCount -= 1
	Global.enemiesKilled += 1
	
	# Vypneme pohyb a kolizi, aby do něj už věže nestřílely
	set_process(false)
	if has_node("CharacterBody2D/CollisionShape2D"):
		$CharacterBody2D/CollisionShape2D.set_deferred("disabled", true)
	
	# Schováme robota a healthbar
	animated_sprite.visible = false
	health_bar.visible = false
	modulate = Color(1, 1, 1)
	
	# Odpálíme jiskry a po dohrání smažeme
	if is_instance_valid(death_particles):
		death_particles.emitting = true
		await get_tree().create_timer(0.35).timeout
		
	queue_free()

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
