extends Area2D

func _on_game_over_dialog_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_game_over_dialog_canceled() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

 

func _on_body_entered(body: Node2D) -> void:
	var enemy = body if "enemy_type" in body else body.get_parent()
	if enemy and "enemy_type" in enemy:
		Global.enemyCount-=1
		body.call_deferred("queue_free")
		match enemy.enemy_type: 
			"lv1": 
				Global.health -= 5
			"lv2":
				Global.health -= 10
		if Global.health <= 0:
			Global.health = 0
			$GameOverDialog.popup_centered()
