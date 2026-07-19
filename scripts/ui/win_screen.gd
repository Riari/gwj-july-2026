extends Control

@onready var time_label: Label = %TimeLabel
@onready var medal_label: RichTextLabel = %MedalLabel
@onready var score_label: Label = %ScoreLabel
@onready var medal_multiplier_label: Label = %MedalMultiplierLabel
@onready var final_score_label: RichTextLabel = %FinalScoreLabel
@onready var new_high_score_label: Label = %NewHighScoreLabel
@onready var main_menu_button: Button = %MainMenuButton
@onready var retry_button: Button = %RetryButton
@onready var next_level_button: Button = %NextLevelButton
@onready var confirmation_window: ConfirmationOverlaidWindow = %ConfirmationWindow
@onready var scene_loader_node = get_tree().root.get_node_or_null(^"SceneLoader")

var _main_menu_scene_path: String = "res://scenes/menus/main_menu/main_menu_with_animations.tscn"
var _current_level_path: String = ""
var _next_level_path: String = ""

var _next_scene_path: String = ""

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

	_current_level_path = LevelUtils.LEVEL_PATHS[level_index]
	var next_level_index := level_index + 1
	if next_level_index < LevelUtils.LEVEL_PATHS.size():
		_next_level_path = LevelUtils.LEVEL_PATHS[next_level_index]
	else:
		next_level_button.visible = false

	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	retry_button.pressed.connect(_on_retry_button_pressed)
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	
	confirmation_window.visible = false
	confirmation_window.confirmed.connect(_on_confirmed)

func _on_main_menu_button_pressed() -> void:
	_next_scene_path = _main_menu_scene_path
	confirmation_window.visible = true

func _on_retry_button_pressed() -> void:
	_next_scene_path = _current_level_path
	confirmation_window.visible = true

func _on_next_level_button_pressed() -> void:
	scene_loader_node.load_scene(_next_level_path)

func _on_confirmed() -> void:
	scene_loader_node.load_scene(_next_scene_path)
