extends Label

func _process(_delta) -> void:
	text = "Health: " + str(Global.health) + "\nEnemies left: " + str(Global.enemyCount) + "\nCurrent level: " + str(Global.level) + "\nGold: " + str(Global.gold)
