extends Control

var btn_locked = preload("res://assets/GUI/levelSelect/level-select-locked.png")
var btn_completed = preload("res://assets/GUI/levelSelect/level-select-completed.png")
var btn_unlocked = preload("res://assets/GUI/levelSelect/level-select-idle.png")

@onready var lvl1Btn: TextureButton = $lvl1Btn
@onready var lvl2Btn: TextureButton = $lvl2Btn
@onready var lvl3Btn: TextureButton = $lvl3Btn
@onready var lvl4Btn: TextureButton = $lvl4Btn
@onready var lvl5Btn: TextureButton = $lvl5Btn

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _ready() -> void:
	lvl1Btn.pivot_offset = lvl1Btn.size / 2
	lvl2Btn.pivot_offset = lvl2Btn.size / 2
	lvl3Btn.pivot_offset = lvl3Btn.size / 2
	lvl4Btn.pivot_offset = lvl4Btn.size / 2
	lvl5Btn.pivot_offset = lvl5Btn.size / 2
	#lvl 1
	if Global.lvl1Completed == true:
		$lvl1Btn.texture_normal = btn_completed
		
	#lvl 2 
	if Global.lvl1Completed == true:
		$lvl2Btn.texture_normal = btn_unlocked
	if Global.lvl2Completed == true:
		$lvl2Btn.texture_normal = btn_completed
	if Global.lvl2Completed == false and Global.lvl1Completed == false: 
		$lvl2Btn.texture_normal = btn_locked
		$lvl2Btn/Label.text = ""
		$lvl2Btn.disabled = true
		
	#lvl 3
	if Global.lvl2Completed == true:
		$lvl3Btn.texture_normal = btn_unlocked
	if Global.lvl3Completed == true:
		$lvl3Btn.texture_normal = btn_completed
	if Global.lvl3Completed == false and Global.lvl2Completed == false: 
		$lvl3Btn.texture_normal = btn_locked
		$lvl3Btn/Label.text = ""
		$lvl3Btn.disabled = true
	
	#lvl 4
	if Global.lvl3Completed == true:
		$lvl4Btn.texture_normal = btn_unlocked
	if Global.lvl4Completed == true:
		$lvl4Btn.texture_normal = btn_completed
	if Global.lvl4Completed == false and Global.lvl3Completed == false: 
		$lvl4Btn.texture_normal = btn_locked
		$lvl4Btn/Label.text = ""
		$lvl4Btn.disabled = true
		
	#lvl 5
	if Global.lvl4Completed == true:
		$lvl5Btn.texture_normal = btn_unlocked
	if Global.lvl5Completed == true:
		$lvl5Btn.texture_normal = btn_completed
	if Global.lvl5Completed == false and Global.lvl4Completed == false: 
		$lvl5Btn.texture_normal = btn_locked
		$lvl5Btn/Label.text = ""
		$lvl5Btn.disabled = true
		
		


func reset(lvl,enemyCount,hp) -> void:
	Global.level = lvl
	Global.enemiesSpawned = enemyCount
	Global.enemiesKilled = 0
	Global.health = hp
	
func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

#Button for level 1
func _on_lvl_1_btn_pressed() -> void:
	reset(1,2,100)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
func _on_lvl_1_btn_mouse_entered() -> void:
	lvl1Btn.scale = Vector2(1.1,1.1)
func _on_lvl_1_btn_mouse_exited() -> void:
	lvl1Btn.scale = Vector2(1.0,1.0)


#Button for level2
func _on_lvl_2_btn_pressed() -> void:
	reset(2,2,100)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
func _on_lvl_2_btn_mouse_entered() -> void:
	lvl2Btn.scale = Vector2(1.1,1.1)
func _on_lvl_2_btn_mouse_exited() -> void:
	lvl2Btn.scale = Vector2(1.0,1.0)



func _on_lvl_3_btn_pressed() -> void:
	reset(3,2,100)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
func _on_lvl_3_btn_mouse_entered() -> void:
	lvl3Btn.scale = Vector2(1.1,1.1)
func _on_lvl_3_btn_mouse_exited() -> void:
	lvl3Btn.scale = Vector2(1.0,1.0)


func _on_lvl_4_btn_pressed() -> void:
	reset(4,2,100)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
func _on_lvl_4_btn_mouse_entered() -> void:
	lvl4Btn.scale = Vector2(1.1,1.1)
func _on_lvl_4_btn_mouse_exited() -> void:
	lvl4Btn.scale = Vector2(1.0,1.0)
	

func _on_lvl_5_btn_pressed() -> void:
	reset(5,2,100)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
func _on_lvl_5_btn_mouse_entered() -> void:
	lvl5Btn.scale = Vector2(1.1,1.1)
func _on_lvl_5_btn_mouse_exited() -> void:
	lvl5Btn.scale = Vector2(1.0,1.0)
	
