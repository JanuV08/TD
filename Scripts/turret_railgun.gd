extends Node2D

@onready var damage_timer: Timer = $DamageTimer

var target: Node2D = null
@export var damage_amount: int = 20
@export var cost: int = 1000

func _get_enemy_node(body: Node2D) -> Node2D:
	if body == null:
		return null
	if body.has_method("take_damage") or "current_hp" in body:
		return body
	if body.get_parent() != null and (body.get_parent().has_method("take_damage") or "current_hp" in body.get_parent()):
		return body.get_parent()
	return null

func _process(_delta: float) -> void:
	if is_instance_valid(target):
		$vez_turrety.look_at(target.global_position)
	else:
		find_target()

func find_target() -> void:
	var overlapping_bodies = $range_Area2D.get_overlapping_bodies()
	
	target = null
	for body in overlapping_bodies:
		var enemy = _get_enemy_node(body)
		if enemy != null:
			target = enemy
			break
			
	if target != null:
		if damage_timer.is_stopped():
			damage_timer.start()
	else:
		damage_timer.stop()

func _on_range_area_2d_body_entered(body: Node2D) -> void:
	var enemy = _get_enemy_node(body)
	if enemy != null:
		if target == null:
			target = enemy
			if damage_timer.is_stopped():
				damage_timer.start()

func _on_range_area_2d_body_exited(body: Node2D) -> void:
	var enemy = _get_enemy_node(body)
	if enemy == target or body == target:
		target = null
		find_target()

func _on_damage_timer_timeout() -> void:
	if is_instance_valid(target):
		if target.has_method("take_damage"):
			target.take_damage(damage_amount)
		elif "current_hp" in target:
			target.current_hp -= damage_amount
			if target.current_hp <= 0:
				target.queue_free()
	else:
		find_target()
