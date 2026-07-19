extends Node2D

@export var ui: InGameUI

@onready var exit_area: Area2D = %Area2D
@onready var scene_loader_node = get_tree().root.get_node_or_null(^"SceneLoader")

var _player_is_in_area: bool = false

var _win_screen_path: String = "res://scenes/game_scene/win_screen.tscn"

func _ready() -> void:
	exit_area.body_entered.connect(_on_body_entered)
	exit_area.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("unloaf") and _player_is_in_area:
		var level := owner as Level
		if level:
			var time := GameState.get_current_level_time()
			var medal := level.calculate_medal(time)
			GameState.finish_level(time, medal)
		scene_loader_node.load_scene(_win_screen_path)

func _on_body_entered(body: Node2D) -> void:
	if body is Character and body.is_player():
		_player_is_in_area = true
		var key_names := InputUtils.get_key_display_names("unloaf")
		var key_names_str := " or ".join(key_names)
		ui.show_hint_text("Press [" + key_names_str + "] to exit!")

func _on_body_exited(body: Node2D) -> void:
	if body is Character and body.is_player():
		_player_is_in_area = false
		ui.hide_hint_text()
