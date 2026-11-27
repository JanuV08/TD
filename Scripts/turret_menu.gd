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
	Music.play_click()
	if Global.gold >= Global.turretLVL1_cost:
		turret_selected.emit(1)
		Global.gold -= Global.turretLVL1_cost
		Music.play_build()
	else:
		print("Nein")
	hide()

func _on_button_2_pressed():
	Music.play_click()

	if Global.gold >= Global.turretLVL2_cost:
		turret_selected.emit(2)
		Global.gold -= Global.turretLVL2_cost
		Music.play_build()
	else:
		print("Nein")
	hide()

func _on_button_3_pressed():
	Music.play_click()
	if Global.gold >= Global.turretLVL3_cost:
		turret_selected.emit(3)
		Global.gold -= Global.turretLVL3_cost
		Music.play_build()
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
	
func setup_for_slot(is_railgun_slot: bool) -> void:
	if is_railgun_slot:
		_set_button_locked(cannon_btn, true)
		_set_button_locked(tesla_btn, true)
		_set_button_locked(railgun_btn, false)
	else:
		_set_button_locked(cannon_btn, false)
		_set_button_locked(tesla_btn, false)
		_set_button_locked(railgun_btn, true)

func _set_button_locked(btn: TextureButton, locked: bool) -> void:
	if btn == null:
		return
	btn.disabled = locked
	if locked:
		btn.modulate = Color(0.35, 0.35, 0.35, 0.6)
	else:
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
