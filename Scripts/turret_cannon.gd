extends Node2D

@onready var damage_timer: Timer = $DamageTimer
@onready var range_shape: CollisionShape2D = $range_Area2D/CollisionShape2D

var target: Node2D = null
@export var damage_amount: int = 14
@export var cost: int = 100
@export var bullet_scene: PackedScene = preload("res://Scenes/Shell_canon.tscn")

var show_range: bool = false

func _get_enemy_node(body: Node2D) -> Node2D:
	if body == null:
		return null
	if body.has_method("take_damage") or "current_hp" in body:
		return body
	if body.get_parent() != null and (body.get_parent().has_method("take_damage") or "current_hp" in body.get_parent()):
		return body.get_parent()
	return null

func _process(_delta: float) -> void:
	if is_instance_valid(target) and not target.get("is_dead"):
		$vez_turrety.look_at(target.global_position)
		$vez_turrety.rotation += deg_to_rad(180)
	else:
		find_target()

func find_target() -> void:
	var overlapping_bodies = $range_Area2D.get_overlapping_bodies()
	
	target = null
	var closest_dist: float = INF
	
	for body in overlapping_bodies:
		var enemy = _get_enemy_node(body)
		if enemy != null and not enemy.get("is_dead"):
			var dist: float = global_position.distance_to(enemy.global_position)
			if dist < closest_dist:
				closest_dist = dist
				target = enemy
			
	if target != null:
		if damage_timer.is_stopped():
			damage_timer.start()
	else:
		damage_timer.stop()

func _on_range_area_2d_body_entered(_body: Node2D) -> void:
	find_target()

func _on_range_area_2d_body_exited(body: Node2D) -> void:
	var enemy = _get_enemy_node(body)
	if enemy == target or body == target:
		target = null
		find_target()

func _on_damage_timer_timeout() -> void:
<<<<<<< Updated upstream
	if is_instance_valid(target):
		$fire.play()
		# --- NOVÉ: Vystřelení vizuálního náboje ---
=======
	find_target()
	if is_instance_valid(target) and not target.get("is_dead"):
		# --- Vystřelení vizuálního náboje ---
>>>>>>> Stashed changes
		if bullet_scene != null:
			var bullet = bullet_scene.instantiate()
			bullet.global_position = $vez_turrety/Marker2D.global_position
			bullet.target_pos = target.global_position
			bullet.look_at(target.global_position)
			get_tree().current_scene.add_child(bullet)
		# ------------------------------------
		
		if target.has_method("take_damage"):
			target.take_damage(damage_amount)
		elif "current_hp" in target:
			target.current_hp -= damage_amount
			if target.current_hp <= 0:
				target.queue_free()

func toggle_range() -> void:
	show_range = not show_range
	queue_redraw()

func _draw() -> void:
	if not show_range or not range_shape:
		return
	
	var circle := range_shape.shape as CircleShape2D
	if circle:
		draw_circle(Vector2.ZERO, circle.radius, Color(0.0, 0.9, 1.0, 0.12))
		draw_arc(Vector2.ZERO, circle.radius, 0, TAU, 64, Color(0.0, 0.9, 1.0, 0.85), 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if show_range and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if global_position.distance_to(get_global_mouse_position()) > 32.0:
			show_range = false
			queue_redraw()
