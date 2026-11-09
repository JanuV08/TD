extends CanvasLayer

@onready var top_btn: TextureButton = $TopBtn
@onready var exit_btn: TextureButton = $TextureRect/ExitBtn
@onready var settings_btn: TextureButton = $TextureRect/SettBtn
@onready var background: TextureRect = $TextureRect

func _on_top_btn_pressed() -> void:
	background.visible = !background.visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		background.visible = !background.visible

func _ready() -> void:
	exit_btn.pivot_offset = exit_btn.size / 2
	settings_btn.pivot_offset = settings_btn.size / 2

func _on_exit_btn_mouse_entered() -> void:
	exit_btn.scale = Vector2(1.1,1.1)

func _on_exit_btn_mouse_exited() -> void:
	exit_btn.scale = Vector2(1.0,1.0)

func _on_sett_btn_mouse_entered() -> void:
	settings_btn.scale = Vector2(1.1,1.1)

func _on_sett_btn_mouse_exited() -> void:
	settings_btn.scale = Vector2(1.0,1.0)

func _on_exit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
