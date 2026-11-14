extends Control

signal turret_selected(turret_type: int)

func _ready():
	hide()

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
