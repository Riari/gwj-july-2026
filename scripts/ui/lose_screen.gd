extends Node

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var main_menu_button: Button = %MainMenuButton
@onready var retry_button: Button = %RetryButton
@onready var scene_loader_node = get_tree().root.get_node_or_null(^"SceneLoader")

func _ready() -> void:
	var player_cat := GameState.get_selected_cat()
	anim_sprite.sprite_frames = SpriteUtils.sprite_frames[player_cat]
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	retry_button.pressed.connect(_on_retry_button_pressed)

func _on_main_menu_button_pressed() -> void:
	scene_loader_node.load_scene("res://scenes/game_scene/main_menu.tscn")

func _on_retry_button_pressed() -> void:
	var level_index := GameState.get_last_level_index()
	var current_level_path := LevelUtils.LEVEL_PATHS[level_index]
	scene_loader_node.load_scene(current_level_path)