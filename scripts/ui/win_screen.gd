extends Control

@onready var time_label: Label = %TimeLabel
@onready var medal_label: RichTextLabel = %MedalLabel
@onready var score_label: Label = %ScoreLabel
@onready var medal_multiplier_label: Label = %MedalMultiplierLabel
@onready var final_score_label: RichTextLabel = %FinalScoreLabel
@onready var new_high_score_label: Label = %NewHighScoreLabel

func _ready() -> void:
	var level_index := GameState.get_last_level_index()
	var level_score := GameState.get_last_level_score()
	var level_time := GameState.get_last_level_time()
	var level_medal := GameState.get_last_level_medal()
	
	var medal_name := MedalUtils.medal_to_string(level_medal)
	var score_multiplier := MedalUtils.get_medal_score_multiplier(level_medal)
	var color := MedalUtils.get_medal_color(level_medal)
	
	var final_score := (int)(level_score * score_multiplier)
	var is_new_high_score := final_score > GameState.get_high_score(level_index)
	if is_new_high_score:
		GameState.set_high_score(level_index, final_score)

	var minutes := int(level_time) / 60
	var seconds := int(level_time) % 60
	var milliseconds := int((level_time - int(level_time)) * 100)
	var time_str := "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	
	time_label.text = "Time: " + time_str
	medal_label.parse_bbcode("Medal: [color=#" + color.to_html() + "]" + medal_name + "[/color]")
	score_label.text = "Score: " + str(level_score)
	medal_multiplier_label.text = "Score Multiplier: " + str(score_multiplier) + "x"
	final_score_label.parse_bbcode("Final Score: [color=green]" + str(final_score) + "[/color]")
	new_high_score_label.visible = is_new_high_score
