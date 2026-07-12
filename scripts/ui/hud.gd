class_name HUD extends Control

func _on_player_character_init(health: int) -> void:
	%HeartBar.init(health)

func _on_player_character_hurt(health_lost: int) -> void:
	%HeartBar.modify(-health_lost)
