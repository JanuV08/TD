extends Node2D

var LVL1: PackedScene = preload("res://Scenes/enemyLVL1.tscn")
var LVL2: PackedScene = preload("res://Scenes/enemyLVL2.tscn")
var LVL3: PackedScene = preload("res://Scenes/enemyLVL3.tscn")
var path_script: Script = preload("res://Scripts/path_follow_2d.gd")

func _process(_delta: float) -> void:
	$enemiesLeft.text = "1".repeat(max(0, 2 - Global.enemiesKilled))
	$gold.text = str(Global.gold)
	$HP.text = str(Global.health) + " / 100"
	$HealthBar.value = Global.health
	if Global.health <= (Global.health * 0.3):
			$HealthBar.tint_progress = Color.RED
	
	if Global.nextBtnPressed == true:
		Global.nextBtnPressed = false 
		$waveButton.disabled = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _ready() -> void:
	Global.enemyCount = 0
	Global.enemiesSpawned = 0

func wait(time) -> void:
	await get_tree().create_timer(time).timeout

func spawn(lvl) -> void:
	Global.enemyCount+=1
	Global.enemiesSpawned+=1
	var path2d = get_node_or_null("Path2D")
	if not path2d or not lvl:
		return
	var new_path_follow = PathFollow2D.new()
	new_path_follow.set_script(path_script)
	
	var new_enemy = lvl.instantiate()
	new_path_follow.add_child(new_enemy)
	path2d.add_child(new_path_follow)

func levelSpawn() -> void:
	match Global.level:
		1: 
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL1)
			
		2:
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL2)
			
		3: 
			spawn(LVL2)
			await wait(0.5)
			spawn(LVL2)
		4: 
			spawn(LVL2)
			await wait(0.5)
			spawn(LVL3)
		5: 
			spawn(LVL3)
			await wait(0.5)
			spawn(LVL3)

func _on_button_pressed() -> void:
	levelSpawn() 
	$waveButton.disabled = true
