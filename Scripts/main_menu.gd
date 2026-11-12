extends Control
@onready var playBtn: TextureButton = $playBtn
@onready var quitBtn: TextureButton = $quitBtn
const LEVEL_SCENE_PATH: String = "res://Scenes/map1.tscn"

@export var bg_rect: ColorRect
@export var btn_initiate: BaseButton
@export var btn_abort: BaseButton

# Výchozí modrá paleta
const DEFAULT_TOP = Color("#2a0520")
const DEFAULT_GRID = Color("#ff007f")
const DEFAULT_HORIZON = Color("#40b8ff")

# Paleta při najetí na INITIATE
const INITIATE_TOP = Color(0.05, 0.75, 0.95)
const INITIATE_GRID = Color(0.0, 0.95, 1.0)
const INITIATE_HORIZON = Color(0.45, 0.95, 1.0)

# Paleta při najetí na ABORT (ladí s jeho růžovým rámečkem)
const ABORT_TOP = Color(0.55, 0.08, 0.28)
const ABORT_GRID = Color(1.0, 0.08, 0.55)
const ABORT_HORIZON = Color(1.0, 0.35, 0.15)

var bg_tween: Tween

func _ready() -> void:
	playBtn.pivot_offset = playBtn.size / 2
	quitBtn.pivot_offset = quitBtn.size / 2
	if btn_initiate:
		btn_initiate.mouse_entered.connect(_change_bg_colors.bind(INITIATE_TOP, INITIATE_GRID, INITIATE_HORIZON))
		btn_initiate.mouse_exited.connect(_change_bg_colors.bind(DEFAULT_TOP, DEFAULT_GRID, DEFAULT_HORIZON))
	
	if btn_abort:
		btn_abort.mouse_entered.connect(_change_bg_colors.bind(ABORT_TOP, ABORT_GRID, ABORT_HORIZON))
		btn_abort.mouse_exited.connect(_change_bg_colors.bind(DEFAULT_TOP, DEFAULT_GRID, DEFAULT_HORIZON))

func _change_bg_colors(top: Color, grid: Color, horizon: Color) -> void:
	if not bg_rect or not bg_rect.material:
		return
	if bg_tween:
		bg_tween.kill()
	
	bg_tween = create_tween().set_parallel(true)
	bg_tween.tween_property(bg_rect.material, "shader_parameter/top_color", top, 0.25)
	bg_tween.tween_property(bg_rect.material, "shader_parameter/grid_color", grid, 0.25)
	bg_tween.tween_property(bg_rect.material, "shader_parameter/horizon_color", horizon, 0.25)

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
