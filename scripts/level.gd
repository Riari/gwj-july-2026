extends Node

func _ready() -> void:
	GameState.reset_score()

@export var game_over_music: AudioStream

@onready var fade_out: ColorRect = %FadeOut
@onready var game_over_label: Label = %GameOverLabel

func _on_player_character_died() -> void:
	ProjectMusicController.fade_out(1.0)
	
	var fade_tween := fade_out.create_tween()
	fade_tween.tween_interval(0.2)
	fade_tween.tween_property(fade_out, "color:a", 1.0, 1.0)
	fade_tween.play()
	await fade_tween.finished
	game_over_label.visible = true

	if game_over_music:
		ProjectMusicController.play_stream(game_over_music)
