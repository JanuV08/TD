extends Control

var posledni: float = 1.0
var muting: bool = false

func _ready() -> void:
	$TextureRect/HSlider.value = Global.volume
	_on_h_slider_value_changed(Global.volume)

func _on_h_slider_value_changed(value: float) -> void:
	Global.volume = value
	if not muting:
		posledni = value
		$TextureRect/mute_button.set_pressed_no_signal(value == 0.0)

	$TextureRect/HSlider/Label.text = str(roundi(value * 100)) + " %"
	AudioServer.set_bus_volume_db(0, linear_to_db(value * value))

	if value >= 2.0:
		$TextureRect/mute_button.texture_normal = preload("res://assets/GUI/dropMenu/volume-icon-full.png")
	elif value >= 1.0:
		$TextureRect/mute_button.texture_normal = preload("res://assets/GUI/dropMenu/volume-icon-half.png")
	elif value >= 0.25:
		$TextureRect/mute_button.texture_normal = preload("res://assets/GUI/dropMenu/volume-icon-quarter.png")
	elif value > 0:
		$TextureRect/mute_button.texture_normal = preload("res://assets/GUI/dropMenu/volume-icon-almost-zero.png")
	else:
		$TextureRect/mute_button.texture_normal = preload("res://assets/GUI/dropMenu/volume-icon-zero.png")

func _on_mute_button_toggled(toggled_on: bool) -> void:
	muting = true
	if toggled_on:
		if $TextureRect/HSlider.value > 0.0:
			posledni = $TextureRect/HSlider.value
		$TextureRect/HSlider.value = 0.0
	else:
		$TextureRect/HSlider.value = posledni if posledni > 0.0 else 1.0
	muting = false

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		var panel := $TextureRect
		var is_inside := Rect2(Vector2.ZERO, panel.size).has_point(panel.get_local_mouse_position())
		if not is_inside:
			visible = false
