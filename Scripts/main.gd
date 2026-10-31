extends Node2D

var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
var enemyLVL2_scene: PackedScene = preload("res://Scenes/enemyLVL2.tscn")
var path_script: Script = preload("res://Scripts/path_follow_2d.gd")



func _ready() -> void:
	Global.enemyCount = 0

func spawn() -> void:
	Global.enemyCount+=1
	var path2d = get_node_or_null("Path2D")
	if not path2d or not enemy_scene:
		return
	var new_path_follow = PathFollow2D.new()
	new_path_follow.set_script(path_script)
	
	var new_enemy = enemy_scene.instantiate()
	new_path_follow.add_child(new_enemy)
	path2d.add_child(new_path_follow)

func spawnLVL2() -> void:
	Global.enemyCount+=1
	var path2d = get_node_or_null("Path2D")
	if not path2d or not enemyLVL2_scene:
		return
	var new_path_follow = PathFollow2D.new()
	new_path_follow.set_script(path_script)
	
	var new_enemy = enemyLVL2_scene.instantiate()
	new_path_follow.add_child(new_enemy)
	path2d.add_child(new_path_follow)

func levelSpawn() -> void:
	match Global.level:
		1: 
			Global.enemiesSpawned = 5
			for i in range(2):
				spawn()
				await get_tree().create_timer(0.5).timeout
			await get_tree().create_timer(3.0).timeout
			for i in range(2):
				spawn()
				await get_tree().create_timer(0.5).timeout
			spawnLVL2()
		2:
			Global.enemiesSpawned = 5
			spawn()
			await get_tree().create_timer(0.5).timeout
			spawnLVL2()
			await get_tree().create_timer(3.0).timeout
			spawn()
			await get_tree().create_timer(0.5).timeout
			spawn()
			await get_tree().create_timer(0.5).timeout
			spawnLVL2()
			

func _on_button_pressed() -> void:
	levelSpawn() 
	$waveButton.disabled = true
