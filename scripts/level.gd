extends Node

@onready var music: AudioStreamPlayer = %Music

func _on_player_character_died() -> void:
	music.stop()
