extends Control 

# Signál, kterým menu předá informaci o vybraném typu věže 
signal turret_selected(turret_type: int)

func _ready(): 
	# Při načtení hry menu skryjeme 
	hide() 


# Propojení signálů pressed() jednotlivých tlačítek v editoru: 
func _on_button_1_pressed(): 
	turret_selected.emit(1) 
	hide() 


func _on_button_2_pressed(): 
	turret_selected.emit(2) 
	hide() 


func _on_button_3_pressed(): 
	turret_selected.emit(3) 
	hide()
