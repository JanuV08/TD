extends Node2D

func _ready() -> void:
	if Global.wave <= 3:
		$CharacterBody2D/Sprite2D.texture = load("res://assets/blue-ball.svg")
		Global.enemyDmg = 5
	if Global.wave >3 && Global.wave <= 6:
		$CharacterBody2D/Sprite2D.texture = load("res://assets/green-ball.svg")
		Global.enemyDmg = 10
