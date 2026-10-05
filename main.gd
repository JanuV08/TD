extends Node2D

var enemy_scene: PackedScene = preload("res://enemy.tscn")
var path_script: Script = preload("res://path_follow_2d.gd")

func _ready() -> void:
	Global.enemyCount = 0

func _process(_delta: float) -> void:
	$waveButton.disabled = (Global.enemyCount > 0)


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


func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.enemyCount-=1
	body.call_deferred("queue_free")
	Global.health -= Global.enemyDmg
	if Global.health <= 0:
		Global.health = 0
		get_tree().paused
		$GameOverDialog.popup_centered()
		

func _on_game_over_dialog_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_game_over_dialog_canceled() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
func waveSpawn() -> void:
	if Global.enemyCount == 0:
		for i in range(Global.wave):
			spawn()
			await get_tree().create_timer(0.3).timeout
		Global.wave += 1
	



func _on_button_pressed() -> void:
	waveSpawn()


func _on_exitbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
