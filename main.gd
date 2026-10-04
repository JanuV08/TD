extends Node2D

# Called when the node enters the scene tree for the first time.
var enemy_scene: PackedScene = preload("res://enemy.tscn")
var path_script: Script = preload("res://path_follow_2d.gd")

func spawn() -> void:
	var path2d = get_node_or_null("Path2D")
	if not path2d or not enemy_scene:
		return
	var new_path_follow = PathFollow2D.new()
	new_path_follow.set_script(path_script)
	
	var new_enemy = enemy_scene.instantiate()
	new_path_follow.add_child(new_enemy)
	path2d.add_child(new_path_follow)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.call_deferred("queue_free")
	Global.health -=10
	call_deferred("spawn")
