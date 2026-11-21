extends Control

@onready var cannon_btn: TextureButton = $TextureRect/TextureButton
@onready var tesla_btn: TextureButton = $TextureRect/TextureButton2
@onready var railgun_btn: TextureButton = $TextureRect/TextureButton3

signal turret_selected(turret_type: int)

func _ready():
	hide()
	cannon_btn.pivot_offset = cannon_btn.size / 2
	tesla_btn.pivot_offset = tesla_btn.size / 2
	railgun_btn.pivot_offset = railgun_btn.size / 2

func _on_button_1_pressed():
	if Global.gold >= Global.turretLVL1_cost:
		turret_selected.emit(1)
		Global.gold -= Global.turretLVL1_cost
	else:
		print("Nein")
	hide()

func _on_button_2_pressed():
	if Global.gold >= Global.turretLVL2_cost:
		turret_selected.emit(2)
		Global.gold -= Global.turretLVL2_cost
	else:
		print("Nein")
	hide()

func _on_button_3_pressed():
	if Global.gold >= Global.turretLVL3_cost:
		turret_selected.emit(3)
		Global.gold -= Global.turretLVL3_cost
	else:
		print("Nein")
	hide()

# Místo $TextureRect.visible = false schováme celé TurretMenu pomocí hide()
func _on_texture_rect_mouse_exited() -> void:
	hide()


func _on_texture_button_mouse_entered() -> void:
	cannon_btn.scale = Vector2(1.1, 1.1)
func _on_texture_button_mouse_exited() -> void:
	cannon_btn.scale = Vector2(1.0, 1.0)

func _on_texture_button_2_mouse_entered() -> void:
	tesla_btn.scale = Vector2(1.1, 1.1)
func _on_texture_button_2_mouse_exited() -> void:
	tesla_btn.scale = Vector2(1.0, 1.0)

func _on_texture_button_3_mouse_entered() -> void:
	railgun_btn.scale = Vector2(1.1, 1.1)
func _on_texture_button_3_mouse_exited() -> void:
	railgun_btn.scale = Vector2(1.0, 1.0)
