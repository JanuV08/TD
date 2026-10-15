extends CanvasLayer

@onready var top_btn: TextureButton = $TopBtn
@onready var exit_btn: TextureButton = $TopBtn/ExitBtn
@onready var settings_btn: TextureButton = $TopBtn/TextureButton
@onready var background: TextureRect = $TopBtn/TextureRect

func _on_top_btn_pressed() -> void:
	background.visible = !background.visible
	exit_btn.visible = !exit_btn.visible
	settings_btn.visible = !settings_btn.visible


func _on_exit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
