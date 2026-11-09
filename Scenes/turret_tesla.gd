extends Node2D

@onready var damage_timer = $DamageTimer

var enemies_in_range: Array = []
var damage_amount: int = 5

# Spustí se, když tělo vstoupí do kruhu (Area2D)
func _on_attack_range_body_entered(body: Node2D) -> void:
	# Ověříme, že objekt je nepřítel (musí mít ve svém uzlu přidělenou skupinu "enemy")
	if body.is_in_group("enemy"): 
		enemies_in_range.append(body)
		
		# Pokud je to první cíl, co vešel, spustíme taktovač poškození
		if enemies_in_range.size() == 1:
			damage_timer.start()

# Spustí se, když tělo opustí kruh (Area2D)
func _on_attack_range_body_exited(body: Node2D) -> void:
	if body in enemies_in_range:
		enemies_in_range.erase(body)
		
		# Pokud rádius všichni opustili, vypneme taktovač
		if enemies_in_range.is_empty():
			damage_timer.stop()

# Spustí se každých X sekund (podle vlastnosti Wait Time na Timeru)
func _on_damage_timer_timeout() -> void:
	# 1. Odstraníme ze seznamu mrtvoly (nepřátele, co už smazal předchozí tik)
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	
	# 2. Pokud po promazání nikdo nezbyl, zastavíme Timer
	if enemies_in_range.is_empty():
		damage_timer.stop()
		return
		
	# 3. Rozdáme poškození všem živým chudákům v dosahu
	for enemy in enemies_in_range:
		# Zkontrolujeme, jestli má nepřítel ve svém skriptu proměnnou "hp"
		if "current_health" in enemy:
			enemy.current_health -= damage_amount
			
			# Věž sama zkontroluje, jestli už nepřítel zaklepal bačkorama
			if enemy.current_health <= 0:
				enemy.queue_free() # Pošle nepřítele do křemíkového nebe
