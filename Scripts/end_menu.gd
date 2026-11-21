extends Control

var star_done = preload("res://assets/GUI/endMenu/end_menu_star_completed.png")

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	if Global.levelWon == false:
		$TextureRect/Label.text = "DEFENSES BREACHED"
		$TextureRect/nextBtn/Label.text = "RETRY"
	if Global.levelWon == true:
		if Global.health >= 75:
			$star_1.texture = star_done
			$star_2.texture = star_done
			$star_3.texture = star_done
		if Global.health < 75 and Global.health >= 50:
			$star_1.texture = star_done
			$star_2.texture = star_done
		if Global.health < 50:
			$star_3.texture = star_done
		
		$TextureRect/Label.text = "SECTOR CLEARED"
		$TextureRect/nextBtn/Label.text = "NEXT"
		if Global.level == 5:
			$TextureRect/nextBtn/Label.text = "MENU"
			$TextureRect/nextBtn.visible = false


func _on_next_btn_pressed() -> void:
	if Global.levelWon:
		Global.level += 1
	else:
		Global.levelWon = false

	Global.nextBtnPressed = true
	Global.health = 100
	Global.enemyCount = 0
	Global.enemiesKilled = 0   
	Global.enemiesSpawned = 0   
	Global.gold = 1000

func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
