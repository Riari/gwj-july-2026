class_name HUD extends Control

@onready var score_label: Label = %ScoreLabel
@onready var score_label_shadow: Label = %ScoreLabelShadow

func on_player_health_init(health: int) -> void:
	%HeartBar.init(health)

func on_player_heal(health_gained: int) -> void:
	%HeartBar.modify(health_gained)

func on_player_hurt(health_lost: int) -> void:
	%HeartBar.modify(-health_lost)

func on_player_scored() -> void:
	score_label.text = "Score: " + str(GameState.get_score())
	score_label_shadow.text = "Score: " + str(GameState.get_score())