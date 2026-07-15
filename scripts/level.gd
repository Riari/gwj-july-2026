extends Node

@export var game_over_music: AudioStream

@onready var in_game_ui: InGameUI = %InGameUI

func _on_player_character_init(health: int) -> void:
	in_game_ui.on_player_character_init(health)

func _on_player_character_hurt(health_lost: int) -> void:
	in_game_ui.on_player_character_hurt(health_lost)

func _on_player_character_heal(health_gained: int) -> void:
	in_game_ui.on_player_character_heal(health_gained)

func _on_player_character_died() -> void:
	await in_game_ui.on_player_character_died()

	if game_over_music:
		ProjectMusicController.play_stream(game_over_music)
