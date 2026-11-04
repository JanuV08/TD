extends Area2D

func _process(_delta: float) -> void:
	if Global.nextBtnPressed == true:
		$CanvasLayer.visible = false

	if Global.enemiesSpawned > 0 and Global.enemiesKilled == Global.enemiesSpawned and Global.health > 0:
		Global.levelWon = true
		if Global.level == 1:
			Global.lvl1Completed = true
		if Global.level == 2:
			Global.lvl2Completed = true
		$CanvasLayer.visible = true
	
	if Global.health <= 0:
		Global.levelWon = false
		if Global.level == 1:
			Global.lvl1Completed = false
		if Global.level == 2:
			Global.lvl2Completed = false
		$CanvasLayer.visible = true

func _on_body_entered(body: Node2D) -> void:
	var enemy = body if "enemy_type" in body else body.get_parent()
	if enemy and "enemy_type" in enemy:
		Global.enemyCount-=1
		Global.enemiesKilled+=1
		body.call_deferred("queue_free")
		match enemy.enemy_type: 
			"lvl1": 
				Global.health -= 5
			"lvl2":
				Global.health -= 10
		if Global.health <= 0:
			Global.health = 0
