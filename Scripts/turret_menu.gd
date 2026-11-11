extends Control 

# Signál, kterým menu předá informaci o vybraném typu věže 
signal turret_selected(turret_type: int)

func _ready(): 
	# Při načtení hry menu skryjeme 
	hide() 
	$TextureRect/TextureButton/Label.text = str(Global.turretLVL1_cost)
	$TextureRect/TextureButton2/Label.text = str(Global.turretLVL2_cost)
	$TextureRect/TextureButton3/Label.text = str(Global.turretLVL3_cost)

# Propojení signálů pressed() jednotlivých tlačítek v editoru: 
func _on_button_1_pressed(): 
	if Global.gold >= Global.turretLVL1_cost:
		turret_selected.emit(1) 
		Global.gold -= Global.turretLVL1_cost
	else:
		print("Nein")
	hide()


func _on_button_2_pressed(): 
	if Global.gold >= Global.turretLVL2_cost:
		turret_selected.emit(2) 
		Global.gold -= Global.turretLVL2_cost
	else:
		print("Nein")
	hide()


func _on_button_3_pressed(): 
	if Global.gold >= Global.turretLVL3_cost:
		turret_selected.emit(3) 
		Global.gold -= Global.turretLVL3_cost
	else:
		print("Nein")
	hide()
