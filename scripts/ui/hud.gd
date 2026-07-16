class_name HUD extends Control

@onready var score_label: Label = %ScoreLabel
@onready var score_label_shadow: Label = %ScoreLabelShadow

var current_score := 0

func _process(_delta):
	if current_score != GameState.get_score():
		score_label.text = "Score: " + str(GameState.get_score())
		score_label_shadow.text = "Score: " + str(GameState.get_score())
		current_score = GameState.get_score()

func on_player_character_init(health: int) -> void:
	%HeartBar.init(health)

func on_player_character_heal(health_gained: int) -> void:
	%HeartBar.modify(health_gained)

func on_player_character_hurt(health_lost: int) -> void:
	%HeartBar.modify(-health_lost)
