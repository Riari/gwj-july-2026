extends Node2D

@export var ui: InGameUI

@onready var exit_area: Area2D = %Area2D

func _ready() -> void:
	exit_area.body_entered.connect(_on_body_entered)
	exit_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Character and body.is_player():
		var key_names := InputUtils.get_key_display_names("unloaf")
		var key_names_str := " or ".join(key_names)
		ui.show_hint_text("Press [" + key_names_str + "] to exit!")

func _on_body_exited(body: Node2D) -> void:
	if body is Character and body.is_player():
		ui.hide_hint_text()
