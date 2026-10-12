extends CanvasLayer


func _on_top_btn_pressed() -> void:
	$TopBtn/DropdownPanel.visible = !$TopBtn/DropdownPanel.visible
	
func _on_set_btn_pressed() -> void:
	pass
	
func _on_exit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
