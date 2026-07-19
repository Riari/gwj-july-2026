class_name InGameUI extends Node

@onready var fade_rect: ColorRect = %FadeRect
@onready var game_over_label: Label = %GameOverLabel
@onready var hint_text_panel: Panel = %HintTextPanel
@onready var hint_text_label: RichTextLabel = %HintTextLabel

func _ready() -> void:
	fade_rect.color.a = 1.0
	var fade_tween := fade_rect.create_tween()
	fade_tween.tween_property(fade_rect, "color:a", 0.0, 0.5)
	fade_tween.play()

func on_player_health_init(health: int) -> void:
	%HUD.on_player_health_init(health)

func on_player_hurt(_instigator: Character, damage: int) -> void:
	%HUD.on_player_hurt(damage)

func on_player_heal(health_gained: int) -> void:
	%HUD.on_player_heal(health_gained)

func on_player_died() -> void:
	ProjectMusicController.fade_out(1.0)
	
	var fade_tween := fade_rect.create_tween()
	fade_tween.tween_interval(0.2)
	fade_tween.tween_property(fade_rect, "color:a", 1.0, 1.0)
	fade_tween.play()
	await fade_tween.finished
	game_over_label.visible = true

func on_player_scored() -> void:
	%HUD.on_player_scored()

func show_hint_text(text: String) -> void:
	hint_text_panel.visible = true
	hint_text_label.parse_bbcode(text)

func hide_hint_text() -> void:
	hint_text_panel.visible = false