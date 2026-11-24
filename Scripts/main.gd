extends Node2D

const VYBUCH = preload("res://Scenes/vybuch_budovy.tscn")
var LVL1: PackedScene = preload("res://Scenes/enemyLVL1.tscn")
var LVL2: PackedScene = preload("res://Scenes/enemyLVL2.tscn")
var LVL3: PackedScene = preload("res://Scenes/enemyLVL3.tscn")
var path_script: Script = preload("res://Scripts/path_follow_2d.gd")

@export var play_idle: Texture2D = preload("res://assets/GUI/gameUI/game_start_idle.png")
@export var play_hover: Texture2D = preload("res://assets/GUI/gameUI/game_start_hover.png")
@export var pause_idle: Texture2D = preload("res://assets/GUI/gameUI/game_pause_idle.png")
@export var pause_hover: Texture2D = preload("res://assets/GUI/gameUI/game_pause_hover.png")

var wave_running: bool = false
var is_paused: bool = false
var is_spawning: bool = false

func _ready() -> void:
	Music.stop_music()
	Music.play_music(preload("res://assets/Sounds/game_loop.wav"))
	Global.enemyCount = 0
	Global.enemiesSpawned = 0
	
	# Pojistka, aby tlačítko fungovalo i když je hra pozastavená
	$waveButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$waveButton.disabled = false
	_update_wave_button()

func _process(_delta: float) -> void:
	$enemiesLeft.text = "1".repeat(max(0, 2 - Global.enemiesKilled))
	$gold.text = str(Global.gold)
	$HP.text = str(Global.health) + " / 5"
	$HealthBar.value = Global.health

	# --- NOVÉ: Kontrola konce vlny, aby se tlačítko vrátilo zpět na PLAY ---
	if wave_running and not is_spawning and Global.enemyCount <= 0:
		wave_running = false
		is_paused = false
		get_tree().paused = false
		_update_wave_button()
	# ----------------------------------------------------------------------

	if Global.nextBtnPressed == true:
		$end_menu.visible = false
		Global.nextBtnPressed = false 
		get_tree().paused = false # Pojistka, ať se další level nenačte zapauzovaný
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
		
	if Global.health <= 4:
		znic($mapa/foreground/budova5)
	if Global.health <= 3:
		znic($mapa/foreground/budova4)
	if Global.health <= 2:
		znic($mapa/foreground/budova3)
	if Global.health <= 1:
		znic($mapa/foreground/budova2)
	if Global.health <= 0:
		znic($mapa/foreground/budova1)

func znic(budova) -> void:
	if not budova.visible or budova.scale != Vector2.ONE:
		return

	var vybuch = VYBUCH.instantiate()
	vybuch.global_position = budova.global_position
	vybuch.z_index = 10
	add_child(vybuch)
	vybuch.emitting = true
	for jiskry in vybuch.get_children():
		if jiskry is CPUParticles2D:
			jiskry.emitting = true
	vybuch.finished.connect(vybuch.queue_free)

	var tween = create_tween()
	budova.modulate = Color(5.0, 2.0, 3.0)
	tween.tween_property(budova, "scale", Vector2(1.25, 1.25), 0.06)
	tween.tween_property(budova, "scale", Vector2.ZERO, 0.25)
	tween.parallel().tween_property(budova, "modulate", Color(1, 1, 1, 0), 0.25)
	tween.tween_callback(func(): budova.visible = false)

	var mapa_tween = create_tween()
	var start_pos = $mapa.position
	mapa_tween.tween_property($mapa, "position", start_pos + Vector2(8, -6), 0.05)
	mapa_tween.tween_property($mapa, "position", start_pos + Vector2(-8, 6), 0.05)
	mapa_tween.tween_property($mapa, "position", start_pos + Vector2(5, 4), 0.05)
	mapa_tween.tween_property($mapa, "position", start_pos, 0.05)

func wait(time) -> void:
	# false jako druhý parametr zajistí, že při pauze hry se zastaví i spawnování dalších mobů!
	await get_tree().create_timer(time, false).timeout

func spawn(lvl) -> void:
	Global.enemyCount += 1
	Global.enemiesSpawned += 1
	var path2d = get_node_or_null("Path2D")
	if not path2d or not lvl:
		return
	var new_path_follow = PathFollow2D.new()
	new_path_follow.set_script(path_script)
	
	var new_enemy = lvl.instantiate()
	new_path_follow.add_child(new_enemy)
	path2d.add_child(new_path_follow)

func levelSpawn() -> void:
	is_spawning = true
	match Global.level:
		1: 
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL1)
		2:
			spawn(LVL1)
			await wait(0.5)
			spawn(LVL2)
		3: 
			spawn(LVL2)
			await wait(0.5)
			spawn(LVL2)
		4: 
			spawn(LVL2)
			await wait(0.5)
			spawn(LVL3)
		5: 
			spawn(LVL3)
			await wait(0.5)
			spawn(LVL3)
	is_spawning = false

# --- UPRAVENÁ FUNKCE PRO TLAČÍTKO ---
func _on_button_pressed() -> void:
	if not wave_running:
		# 1. Vlna ještě neběží -> spustíme ji
		wave_running = true
		is_paused = false
		get_tree().paused = false
		_update_wave_button()
		levelSpawn()
	else:
		# 2. Vlna už běží -> přepínáme pauzu
		is_paused = not is_paused
		get_tree().paused = is_paused
		_update_wave_button()

func _update_wave_button() -> void:
	if not wave_running or is_paused:
		$waveButton.texture_normal = play_idle
		$waveButton.texture_hover = play_hover
	else:
		$waveButton.texture_normal = pause_idle
		$waveButton.texture_hover = pause_hover
