extends Control

var star_done = preload("res://assets/GUI/endMenu/end_menu_star_completed.png")
var spusteno: bool = false

# Počet levelů ve hře (zatím máte 1 level s 8 vlnami; až přidáte další mapy, zvedněte číslo)
const TOTAL_LEVELS: int = 5

func _ready() -> void:
	# Pojistka, aby tlačítka Retry a Menu fungovala i po zapauzování hry
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _process(_delta: float) -> void:
	# 1. Okamžitá prohra, jakmile dojdou životy základny (nemusí se čekat na konec vlny)
	if Global.health <= 0 and not spusteno:
		visible = true

	# 2. Spustí se jen jednou ve chvíli, kdy se menu zobrazí (výhra z main.gd nebo prohra výše)
	if visible and not spusteno:
		spusteno = true
		Music.stop_music()
		get_tree().paused = true
		
		if Global.health > 0:
			# --- VÝHRA (všech 8 vln poraženo) ---
			$levelWon.play()
			Global.levelWon = true
			_set_level_completed(Global.level, true)
			
			if Global.health == 5:
				$TextureRect/star_1.texture = star_done
				$TextureRect/star_2.texture = star_done
				$TextureRect/star_3.texture = star_done
			elif Global.health >= 3:
				$TextureRect/star_1.texture = star_done
				$TextureRect/star_2.texture = star_done
			else:
				$TextureRect/star_1.texture = star_done
				
			$TextureRect/Label.text = "SECTOR CLEARED"
			$TextureRect/nextBtn/Label.text = "NEXT"
			
			# Pokud je tohle poslední (jediný) level, skryjeme tlačítko NEXT a necháme jen MENU
			if Global.level >= TOTAL_LEVELS:
				$TextureRect/nextBtn.visible = false
		else:
			# --- PROHRA ---
			$levelLost.play()
			Global.levelWon = false
			$TextureRect/Label.text = "DEFENSES BREACHED"
			$TextureRect/nextBtn.visible = true
			$TextureRect/nextBtn/Label.text = "RETRY"

func _set_level_completed(lvl: int, completed: bool) -> void:
	match lvl:
		1: Global.lvl1Completed = completed
		2: Global.lvl2Completed = completed
		3: Global.lvl3Completed = completed
		4: Global.lvl4Completed = completed
		5: Global.lvl5Completed = completed

func _reset_global_stats() -> void:
	Global.health = 5
	Global.enemyCount = 0
	Global.enemiesKilled = 0
	Global.enemiesSpawned = 0
	Global.gold = 250 # Startovní zlato podle vybalancované ekonomiky

func _on_next_btn_pressed() -> void:
	Music.play_click()
	if Global.levelWon:
		Global.level += 1
	else:
		Global.levelWon = false

	_reset_global_stats()
	spusteno = false
	visible = false
	get_tree().paused = false
	Global.nextBtnPressed = true

func _on_menu_btn_pressed() -> void:

	Music.play_click()

	_reset_global_stats()
	Global.levelWon = false
	spusteno = false
	get_tree().paused = false

	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
