class_name Level extends Node

@export var game_over_music: AudioStream

func on_player_health_init(health: int) -> void:
	%InGameUI.on_player_health_init(health)

func on_player_hurt(instigator: Character, damage: int) -> void:
	%InGameUI.on_player_hurt(instigator, damage)

func _on_player_healed(health_gained: int) -> void:
	%InGameUI.on_player_heal(health_gained)

func _on_player_died() -> void:
	await %InGameUI.on_player_died()

	if game_over_music:
		ProjectMusicController.play_stream(game_over_music)

func _on_player_scored(score: int) -> void:
	GameState.add_score(score)
	%InGameUI.on_player_scored()
