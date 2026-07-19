extends Control

@onready var time_label: Label = %TimeLabel
@onready var medal_label: Label = %MedalLabel
@onready var score_label: Label = %ScoreLabel

func _ready() -> void:
	var time := GameState.get_last_level_time()
	var minutes := int(time) / 60
	var seconds := int(time) % 60
	var milliseconds := int((time - int(time)) * 100)
	var time_str := "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	
	time_label.text = "Time: " + time_str
	
	var medal := GameState.get_last_level_medal()
	medal_label.text = "Medal: " + medal
	
	var score := GameState.get_score()
	score_label.text = "Score: " + str(score)
