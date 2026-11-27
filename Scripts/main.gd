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

@export var starting_gold: int = 250

const MAX_WAVES: int = 8
var current_wave: int = 1
var wave_total_enemies: int = 0

var wave_running: bool = false
var is_paused: bool = false
var is_spawning: bool = false

func _ready() -> void:
	Music.stop_music()
	Music.play_music(preload("res://assets/Sounds/game_loop.wav"))
	
	# Odstraníme z paměti všechny levely kromě aktuálně hraného (Global.level)
	for i in range(1, 6):
		var lvl_node = get_node_or_null("Level" + str(i))
		if lvl_node and i != Global.level:
			lvl_node.queue_free()
	
	current_wave = 1
	Global.gold = starting_gold
	Global.enemyCount = 0
	Global.enemiesSpawned = 0
	Global.enemiesKilled = 0
	
	$waveButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$waveButton.disabled = false
	_update_wave_button()

# Vrátí uzel aktuálního levelu (Level1..Level5), nebo samotný main jako zálohu
func _get_active_level_root() -> Node:
	var lvl_node = get_node_or_null("Level" + str(Global.level))
	return lvl_node if lvl_node != null else self

func _process(_delta: float) -> void:
	$enemiesLeft.text = "1".repeat(max(0, wave_total_enemies - Global.enemiesKilled))
	$gold.text = str(Global.gold)
	$HP.text = str(Global.health) + " / 5"
	$HealthBar.value = Global.health

	# Kontrola konce aktuální vlny
	if wave_running and not is_spawning and Global.enemyCount <= 0:
		wave_running = false
		is_paused = false
		get_tree().paused = false
		
		if current_wave < MAX_WAVES:
			current_wave += 1
			_update_wave_button()
		else:
			$waveButton.disabled = true
			_update_wave_button()
			if has_node("end_menu") and Global.health > 0:
				$end_menu.visible = true

	# Restart celé scény main.tscn pro NEXT i RETRY (načte další Global.level)
	if Global.nextBtnPressed == true:
		$end_menu.visible = false
		Global.nextBtnPressed = false
		get_tree().paused = false
		get_tree().reload_current_scene()

	var lvl_root = _get_active_level_root()
	for i in range(1, 6):
		if Global.health <= (i - 1):
			var budova = lvl_root.get_node_or_null("mapa/foreground/budova" + str(i))
			if budova:
				znic(budova)

func znic(budova) -> void:
	if not budova.visible or budova.scale != Vector2.ONE:
		return

	$mapa/vybuchSound.play()
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

	var mapa = _get_active_level_root().get_node_or_null("mapa")
	if mapa:
		var mapa_tween = create_tween()
		var start_pos = mapa.position
		mapa_tween.tween_property(mapa, "position", start_pos + Vector2(8, -6), 0.05)
		mapa_tween.tween_property(mapa, "position", start_pos + Vector2(-8, 6), 0.05)
		mapa_tween.tween_property(mapa, "position", start_pos + Vector2(5, 4), 0.05)
		mapa_tween.tween_property(mapa, "position", start_pos, 0.05)

func wait(time: float) -> void:
	await get_tree().create_timer(time, false).timeout

func spawn(lvl: PackedScene) -> void:
	Global.enemyCount += 1
	Global.enemiesSpawned += 1
	var path2d = _get_active_level_root().get_node_or_null("Path2D")
	if not path2d or not lvl:
		return
	var new_path_follow = PathFollow2D.new()
	new_path_follow.set_script(path_script)
	
	var new_enemy = lvl.instantiate()
	# V Levelu 1 je násobič 1.0x, v Levelu 2 1.15x, v Levelu 5 1.60x
	var hp_mult: float = 1.0 + (Global.level - 1) * 0.15
	new_enemy.max_hp = roundi(new_enemy.max_hp * hp_mult)
	
	new_path_follow.add_child(new_enemy)
	path2d.add_child(new_path_follow)

func spawn_group(enemy_scene: PackedScene, count: int, delay: float = 0.6) -> void:
	for i in range(count):
		spawn(enemy_scene)
		await wait(delay)

func spawn_wave(wave: int) -> void:
	is_spawning = true
	Global.enemiesSpawned = 0
	Global.enemiesKilled = 0
	
	var mult: float = 1.0 + (Global.level - 1) * 0.2
	var c1: int = 0; var d1: float = 0.6
	var c2: int = 0; var d2: float = 0.7
	var c3: int = 0; var d3: float = 0.9
	
	match wave:
		1:
			c1 = roundi(8 * mult); d1 = 0.7
		2:
			c1 = roundi(14 * mult); d1 = 0.6
		3:
			c1 = roundi(8 * mult); d1 = 0.6
			c2 = roundi(3 * mult); d2 = 0.8
		4:
			c1 = roundi(10 * mult); d1 = 0.6
			c2 = roundi(6 * mult); d2 = 0.7
		5:
			c1 = roundi(8 * mult); d1 = 0.6
			c2 = roundi(4 * mult); d2 = 0.7
			c3 = maxi(1, roundi(1 * mult)); d3 = 1.0
		6:
			c1 = roundi(15 * mult); d1 = 0.5
			c2 = roundi(6 * mult); d2 = 0.7
			c3 = roundi(2 * mult); d3 = 1.0
		7:
			c1 = roundi(12 * mult); d1 = 0.5
			c2 = roundi(8 * mult); d2 = 0.6
			c3 = roundi(3 * mult); d3 = 0.9
		8:
			c1 = roundi(20 * mult); d1 = 0.45
			c2 = roundi(8 * mult); d2 = 0.6
			c3 = roundi(5 * mult); d3 = 0.8
			
	wave_total_enemies = c1 + c2 + c3
	if c1 > 0: await spawn_group(LVL1, c1, d1)
	if c2 > 0: await spawn_group(LVL2, c2, d2)
	if c3 > 0: await spawn_group(LVL3, c3, d3)
	
	is_spawning = false

func _on_button_pressed() -> void:
	if not wave_running:
		if current_wave > MAX_WAVES:
			return
		wave_running = true
		is_paused = false
		get_tree().paused = false
		_update_wave_button()
		spawn_wave(current_wave)
	else:
		is_paused = not is_paused
		get_tree().paused = is_paused
		_update_wave_button()

func _update_wave_button() -> void:
	if not wave_running or is_paused:
		Music.play_click()
		$waveButton.texture_normal = play_idle
		$waveButton.texture_hover = play_hover
	else:
		Music.play_click()
		$waveButton.texture_normal = pause_idle
		$waveButton.texture_hover = pause_hover
