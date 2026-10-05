extends Control



const LEVEL_SCENE_PATH: String = "res://main.tscn"

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_SCENE_PATH)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
