extends Control

#func _process(_delta: float) -> void:
	#if Global.levelWon:
	#	$TextureRect/Label.text = "You won"
	#else:
	#	$TextureRect/Label.text = "You lost"
