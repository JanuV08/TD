extends Control

func _ready() -> void:
	$ColorRect/TextureRect/HSlider.value = Global.volume
	$ColorRect/TextureRect/HSlider/Label.text = str(Global.volume * 100) + " %"

func _on_h_slider_value_changed(value: float) -> void:
	Global.volume = value
	$ColorRect/TextureRect/HSlider/Label.text = str(Global.volume * 100) + " %"
	# value * value posune střed posuvníku (0.5) na 0.25 (-12 dB), což zní přirozeně
	AudioServer.set_bus_volume_db(0, linear_to_db(value * value))

func _on_button_pressed() -> void:
	$audio_test.play()


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		var panel := $ColorRect/TextureRect
		var is_inside := Rect2(Vector2.ZERO, panel.size).has_point(panel.get_local_mouse_position())
		if not is_inside:
			visible = false
