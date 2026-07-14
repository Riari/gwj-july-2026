class_name HUD extends Control

func _process(_delta):
	var score_label = get_node("ScoreLabel")
	score_label.text = "Score: " + str(GameState.get_score())

func _on_player_character_init(health: int) -> void:
	%HeartBar.init(health)

func _on_player_character_heal(health_gained: int) -> void:
	%HeartBar.modify(health_gained)

func _on_player_character_hurt(health_lost: int) -> void:
	%HeartBar.modify(-health_lost)
