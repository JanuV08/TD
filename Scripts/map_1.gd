extends Control

@onready var lvl1Btn: TextureButton = $lvl1Btn
@onready var lvl2Btn: Button = $lvl2Btn

func _ready() -> void:
	lvl1Btn.pivot_offset = lvl1Btn.size / 2
	lvl2Btn.pivot_offset = lvl2Btn.size / 2
	if Global.lvl1Completed == true:
		$lvl1Btn.disabled = true

#Button for level 1
func _on_lvl_1_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	Global.level = 1
	Global.enemiesSpawned = 5
	Global.enemiesKilled = 0
	Global.health = 30

func _on_lvl_1_btn_mouse_entered() -> void:
	lvl1Btn.scale = Vector2(1.1,1.1)

func _on_lvl_1_btn_mouse_exited() -> void:
	lvl1Btn.scale = Vector2(1.0,1.0)


#Button for level2
func _on_lvl_2_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
	Global.level = 2
	Global.enemiesSpawned = 5
	Global.enemiesKilled = 0
	Global.health = 100

func _on_lvl_2_btn_mouse_entered() -> void:
	lvl2Btn.scale = Vector2(1.1,1.1)

func _on_lvl_2_btn_mouse_exited() -> void:
	lvl2Btn.scale = Vector2(1.0,1.0)
