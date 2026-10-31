extends Area2D

@onready var viewport_size: Vector2 = get_viewport_rect().size

func _on_game_over_dialog_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_game_over_dialog_canceled() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _process(_delta: float) -> void:
	if Global.enemiesKilled == Global.enemiesSpawned && Global.health != 0:
		Global.levelWon = true
		if Global.level	== 1:
			Global.lvl1Completed = true
		if Global.level == 2:
			Global.lvl2Completed = true
		$CanvasLayer/end_menu.visible = true


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
