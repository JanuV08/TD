extends Control

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Global.levelWon == false:
		$TextureRect/Label.text = "DEFENSES BREACHED"
		$TextureRect/nextBtn/Label.text = "RETRY"
	if Global.levelWon == true:
		$TextureRect/Label.text = "SECTOR CLEARED"
		$TextureRect/nextBtn/Label.text = "NEXT"


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
	print("funguj")
	$ColorRect.visible = false
	$TextureRect.visible = false

func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
