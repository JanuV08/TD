extends Control
@onready var playBtn: TextureButton = $playBtn
@onready var quitBtn: TextureButton = $quitBtn
const LEVEL_SCENE_PATH: String = "res://Scenes/map1.tscn"

func _ready() -> void:
	playBtn.pivot_offset = playBtn.size / 2
	quitBtn.pivot_offset = quitBtn.size / 2

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_SCENE_PATH)

func _on_play_btn_mouse_entered() -> void:
	playBtn.scale = Vector2(1.1, 1.1)

func _on_play_btn_mouse_exited() -> void:
	playBtn.scale = Vector2(1.0,1.0)

func _on_quit_btn_mouse_entered() -> void:
	quitBtn.scale = Vector2(1.1, 1.1)

func _on_quit_btn_mouse_exited() -> void:
	quitBtn.scale = Vector2(1.0,1.0)

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
