extends Control

signal game_started
signal back_pressed

var selected: int = -1

@onready var panels := [%CatGrey, %CatOrange, %CatBlack]
@onready var start := %StartButton

var _highlight: StyleBoxFlat
var _unselected: StyleBoxFlat

const selectable_cats: Array = [SpriteUtils.Type.CAT_GREY, SpriteUtils.Type.CAT_ORANGE, SpriteUtils.Type.CAT_BLACK]

func _ready() -> void:
	_unselected = StyleBoxFlat.new()
	_unselected.bg_color = Color(0.9372549, 0.49019608, 0.34117648, 0.0)
	_unselected.set_border_width_all(2)
	_unselected.border_color = Color(0.5, 0.5, 0.5, 1)
	_highlight = StyleBoxFlat.new()
	_highlight.bg_color = Color(0.9372549, 0.49019608, 0.34117648, 0.0)
	_highlight.set_border_width_all(3)
	_highlight.border_color = Color.YELLOW

	for i in 3:
		panels[i].get_node("Button").pressed.connect(_click.bind(i))
		var preview: AnimatedSprite2D = panels[i].get_node("VBox/PreviewContainer/Preview")
		preview.animation_finished.connect(_on_preview_animation_finished.bind(preview))
		preview.play("idle")
		if selectable_cats[i] == GameState.get_selected_cat():
			_click(i)

	_update_start()


func _on_preview_animation_finished(preview: AnimatedSprite2D) -> void:
	if preview.animation == "jump":
		preview.play("idle")


func _click(i: int) -> void:
	if selected >= 0:
		panels[selected].add_theme_stylebox_override("panel", _unselected)
		panels[selected].get_node("VBox/PreviewContainer/Preview").play("idle")

	selected = i
	panels[i].add_theme_stylebox_override("panel", _highlight)
	panels[i].get_node("VBox/PreviewContainer/Preview").play("jump")
	_update_start()

func _on_start_button_pressed() -> void:
	GameState.set_selected_cat(selectable_cats[selected])
	game_started.emit()
	hide()

func _on_back_button_pressed() -> void:
	back_pressed.emit()
	hide()


func _update_start() -> void:
	start.disabled = selected < 0
