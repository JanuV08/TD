extends Control

var star_done = preload("res://assets/GUI/endMenu/end_menu_star_completed.png")
var spusteno: bool = false
func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	if Global.enemiesSpawned > 0 and Global.enemiesKilled == Global.enemiesSpawned and Global.health > 0:
		if not spusteno:
			spusteno = true
			Music.stop_music()
			$levelWon.play()
		Global.levelWon = true
		if Global.level == 1:
			Global.lvl1Completed = true
		if Global.level == 2:
			Global.lvl2Completed = true
		if Global.level == 3:
			Global.lvl3Completed = true
		if Global.level == 4:
			Global.lvl4Completed = true
		if Global.level == 5:
			Global.lvl5Completed = true
		visible = true
	
	if Global.enemiesSpawned > 0 and Global.enemiesKilled == Global.enemiesSpawned and Global.health <= 0:
		if not spusteno:
			spusteno = true
			Music.stop_music()
			$levelLost.play()
		Global.levelWon = false
		if Global.level == 1:
			Global.lvl1Completed = false
		if Global.level == 2:
			Global.lvl2Completed = false
		if Global.level == 3:
			Global.lvl3Completed = false
		if Global.level == 4:
			Global.lvl4Completed = false
		if Global.level == 5:
			Global.lvl5Completed = false
		visible = true
	
	
	if Global.levelWon == false:
		$TextureRect/Label.text = "DEFENSES BREACHED"
		$TextureRect/nextBtn/Label.text = "RETRY"
	if Global.levelWon == true:
		if Global.health == 5:
			$TextureRect/star_1.texture = star_done
			$TextureRect/star_2.texture = star_done
			$TextureRect/star_3.texture = star_done
		if Global.health == 4 or Global.health == 3:
			$TextureRect/star_1.texture = star_done
			$TextureRect/star_2.texture = star_done
		if Global.health < 3:
			$TextureRect/star_3.texture = star_done
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
	visible = false
	Global.health = 5
	Global.enemyCount = 0
	Global.enemiesKilled = 0   
	Global.enemiesSpawned = 0   
	Global.gold = 1000


func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
