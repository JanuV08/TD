extends Area2D

var is_occupied = false
var current_turret = null

@export var turret_cannon_scene: PackedScene = preload("res://Scenes/Turret_cannon.tscn")
@export var turret_tesla_scene: PackedScene = preload("res://Scenes/Turret_tesla.tscn")
@export var selection_menu_scene: PackedScene = preload("res://Scenes/TurretMenu.tscn")

var selection_menu_instance = null

func _ready():
	$AnimatedSprite2D.play("default")

	if selection_menu_scene:
		selection_menu_instance = selection_menu_scene.instantiate()
		add_child(selection_menu_instance)
		selection_menu_instance.turret_selected.connect(_on_turret_selected)

func _on_mouse_entered():
	if not is_occupied:
		$AnimatedSprite2D.play("hover")


func _on_mouse_exited():
	if not is_occupied:
		$AnimatedSprite2D.play("default")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_occupied:
			if selection_menu_instance:
				selection_menu_instance.show()
		else:
			print("Blok je obsazen!")

func _on_turret_selected(turret_type: int):
	spawn_turret(turret_type)

func spawn_turret(turret_type: int):
	is_occupied = true
	if turret_type == 1:
		var turret = turret_cannon_scene.instantiate()
		turret.global_position = global_position
		get_tree().current_scene.add_child(turret)
		current_turret = turret
	if turret_type == 2:
		var turret = turret_tesla_scene.instantiate()
		turret.global_position = global_position
		get_tree().current_scene.add_child(turret)
		current_turret = turret
		
	$AnimatedSprite2D.play("occupied")
