extends Node2D

var enemyLVL1_scene: PackedScene = preload("res://Scenes/enemyLVL1.tscn")
var enemyLVL2_scene: PackedScene = preload("res://Scenes/enemyLVL2.tscn")
var enemyLVL3_scene: PackedScene = preload("res://Scenes/enemyLVL3.tscn")
var path_script: Script = preload("res://Scripts/path_follow_2d.gd")

func _process(_delta: float) -> void:
	$enemiesLeft.text = "1".repeat(max(0, 5 - Global.enemiesKilled))
	$gold.text = "100" #str(Global.gold)
	
	
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

func wait(time) -> void:
	await get_tree().create_timer(time).timeout

func spawn(lvl) -> void:
	Global.enemyCount+=1
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
			Global.enemiesSpawned = 5
			
			spawn(enemyLVL1_scene)
			await wait(0.5)
			spawn(enemyLVL1_scene)
			await wait(3)
			
			spawn(enemyLVL1_scene)
			await wait(0.5)
			spawn(enemyLVL1_scene)
			await wait(0.5)
			spawn(enemyLVL2_scene)
		2:
			Global.enemiesSpawned = 5
			
			spawn(enemyLVL1_scene)
			await wait(0.5)
			spawn(enemyLVL2_scene)
			await wait(3)
			
			spawn(enemyLVL1_scene)
			await wait(0.5)
			spawn(enemyLVL2_scene)
			await wait(0.5)
			spawn(enemyLVL2_scene)
			await wait(0.5)
			spawn(enemyLVL3_scene)
			

func _on_button_pressed() -> void:
	levelSpawn() 
	$waveButton.disabled = true
