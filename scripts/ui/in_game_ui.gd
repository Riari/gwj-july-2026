class_name InGameUI extends Node

@onready var fade_rect: ColorRect = %FadeRect
@onready var hud: HUD = %HUD
@onready var game_over_label: Label = %GameOverLabel

func _ready() -> void:
	GameState.reset_score()
	fade_rect.color.a = 1.0
	var fade_tween := fade_rect.create_tween()
	fade_tween.tween_property(fade_rect, "color:a", 0.0, 0.5)
	fade_tween.play()

func on_player_character_init(health: int) -> void:
	hud.on_player_character_init(health)

func on_player_character_hurt(health_lost: int) -> void:
	hud.on_player_character_hurt(health_lost)

func on_player_character_heal(health_gained: int) -> void:
	hud.on_player_character_heal(health_gained)

func on_player_character_died() -> void:
	ProjectMusicController.fade_out(1.0)
	
	var fade_tween := fade_rect.create_tween()
	fade_tween.tween_interval(0.2)
	fade_tween.tween_property(fade_rect, "color:a", 1.0, 1.0)
	fade_tween.play()
	await fade_tween.finished
	game_over_label.visible = true