class_name Level extends Node

@export var level_index: int = 0
@export var gold_time: float = 30.0
@export var silver_time: float = 60.0
@export var bronze_time: float = 90.0
@onready var scene_loader_node = get_tree().root.get_node_or_null(^"SceneLoader")

var _lose_screen_scene_path: String = "res://scenes/game_scene/lose_screen.tscn"
var current_score := 0

func _ready() -> void:
	GameState.start_level_timer()
	GameState.set_last_level_index(level_index)
	%InGameUI.on_fade_out_complete.connect(_on_fade_out_complete)

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

func _on_fade_out_complete() -> void:
	scene_loader_node.load_scene(_lose_screen_scene_path)

func on_player_scored(score: int) -> void:
	current_score += score
	%InGameUI.on_player_scored(current_score)
