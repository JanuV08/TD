extends Node

@onready var player: AudioStreamPlayer = $lobby_music

func play_music(nova_hudba: AudioStream) -> void:
	# Pokud už stejná skladba hraje, nerestartuje se od začátku
	if player.stream == nova_hudba and player.playing:
		return
	player.stream = nova_hudba
	player.play()

func stop_music() -> void:
	player.stop()
	
func play_click() -> void:
	$ClickPlayer.play()

func play_build() -> void:
	$BuildSound.play()
