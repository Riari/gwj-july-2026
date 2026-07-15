extends Node

@export var game_over_music: AudioStream

@onready var in_game_ui: InGameUI = %InGameUI

func _on_player_character_died() -> void:
	await in_game_ui.on_player_character_died()

	if game_over_music:
		ProjectMusicController.play_stream(game_over_music)
