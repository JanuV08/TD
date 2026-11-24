extends Area2D

func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	var enemy = body if "enemy_type" in body else body.get_parent()
	if enemy and "enemy_type" in enemy:
		Global.enemyCount-=1
		Global.enemiesKilled+=1
		body.call_deferred("queue_free")
		match enemy.enemy_type: 
			"lvl1": 
				Global.health -= enemy.damage_to_base
			"lvl2":
				Global.health -= enemy.damage_to_base
			"lvl3":
				Global.health -= enemy.damage_to_base
		
		if Global.health <= 0:
			Global.health = 0
