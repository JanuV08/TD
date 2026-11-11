extends Node2D

@onready var damage_timer = $DamageTimer

var enemies_in_range: Array = []
var damage_amount: int = 10
@export var cost: int = 250

func _get_enemy_node(body: Node2D) -> Node2D:
	if body == null:
		return null
		
	# Pokud má skript přímo body (je to přímo kořen nepřítele)
	if body.has_method("take_damage"):
		return body
		
	# Pokud má skript rodič (body je CharacterBody2D / Area2D)
	var parent = body.get_parent()
	if parent != null and parent.has_method("take_damage"):
		return parent
		
	# Založeno na skupině "enemy"
	if body.is_in_group("enemy"):
		return body
	if parent != null and parent.is_in_group("enemy"):
		return parent
		
	return null

func _on_attack_range_body_entered(body: Node2D) -> void:
	var enemy = _get_enemy_node(body)
	print("ENTER: body=", body.name, " -> vysledny enemy=", enemy)
	
	if enemy and not enemy in enemies_in_range:
		enemies_in_range.append(enemy)
		print("Pocet nepriatel v dosahu: ", enemies_in_range.size())
		if damage_timer.is_stopped():
			damage_timer.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	var enemy = _get_enemy_node(body)
	print("EXIT: body=", body.name, " -> vysledny enemy=", enemy)
	
	if enemy in enemies_in_range:
		enemies_in_range.erase(enemy)
	elif body in enemies_in_range:
		enemies_in_range.erase(body)
		
	_clean_enemies_array()

func _on_damage_timer_timeout() -> void:
	_clean_enemies_array()
	
	if enemies_in_range.is_empty():
		damage_timer.stop()
		return
		
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage_amount)
			elif "current_hp" in enemy:
				enemy.current_hp -= damage_amount
				if enemy.current_hp <= 0:
					enemy.queue_free()
# Pomocná funkce na promazání smazaných objektů (mrtvol)
func _clean_enemies_array() -> void:
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	if enemies_in_range.is_empty() and not damage_timer.is_stopped():
		damage_timer.stop()
