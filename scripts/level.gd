class_name Level extends Node

@export var game_over_music: AudioStream

@export var gold_time: float = 60.0
@export var silver_time: float = 120.0
@export var bronze_time: float = 180.0

func _ready() -> void:
	GameState.start_level_timer()

func _process(delta: float) -> void:
	GameState.update_level_timer(delta)

func calculate_medal(time: float) -> String:
	if time <= gold_time:
		return "Gold"
	elif time <= silver_time:
		return "Silver"
	elif time <= bronze_time:
		return "Bronze"
	else:
		return "None"

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
