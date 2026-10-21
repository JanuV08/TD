extends Area2D


func _on_game_over_dialog_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_game_over_dialog_canceled() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")



func _on_body_entered(body: Node2D) -> void:
		Global.enemyCount-=1
		body.call_deferred("queue_free")
		Global.health -= Global.enemyDmg
		if Global.health <= 0:
			Global.health = 0
			$GameOverDialog.popup_centered()
