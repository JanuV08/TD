extends Control

func _on_level_1_pressed() -> void:	
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	Global.wave = 1
