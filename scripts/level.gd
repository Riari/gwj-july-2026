class_name Level extends Node

@export var game_over_music: AudioStream

@export var level_index: int = 0
@export var gold_time: float = 30.0
@export var silver_time: float = 60.0
@export var bronze_time: float = 90.0

var current_score := 0

func _ready() -> void:
	GameState.start_level_timer()

func _process(delta: float) -> void:
	GameState.update_level_timer(delta)

func calculate_medal(time: float) -> MedalUtils.Medal:
	if time <= gold_time:
		return MedalUtils.Medal.GOLD
	elif time <= silver_time:
		return MedalUtils.Medal.SILVER
	elif time <= bronze_time:
		return MedalUtils.Medal.BRONZE
	else:
		return MedalUtils.Medal.NONE

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
	current_score += score
	%InGameUI.on_player_scored(current_score)
