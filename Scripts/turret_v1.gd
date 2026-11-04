extends Node2D

var target = null # Ukládáme si aktuálního nepřítele

func _process(_delta):
	# 1. Pokud máme cíl a stále žije
	if is_instance_valid(target):
		# Hlaveň se plynule otočí směrem k nepříteli
		$vez_turrety.look_at(target.global_position)
		
		# Kdyby se hlaveň točila zadem, odkomentuj tenhle řádek:
		# $vez_turrety.rotation += deg_to_rad(180)
	else:
		# Pokud cíl není, zkusíme najít nového
		find_target()

func find_target():
	# Získáme všechny objekty, které vstoupily do dosahu Area2D
	var overlapping_bodies = $range_Area2D.get_overlapping_bodies()
	
	if overlapping_bodies.size() > 0:
		# Vezmeme prvního nalezeného nepřítele
		target = overlapping_bodies[0]
	else:
		target = null

# Signál: Jakmile nepřítel vstoupí do kruhu dosahu (název opraven podle RangeArea2D)
func _on_range_area_2d_body_entered(body: Node2D) -> void:
	if target == null:
		target = body

# Signál: Jakmile nepřítel z kruhu odejde (název opraven podle RangeArea2D)
func _on_range_area_2d_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		find_target() # Zkusíme najít jiného, pokud tam ještě někdo je
