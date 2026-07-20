class_name Pickup extends Area2D

@export var heal_value: int = 1
@export var indicator_move_offset: int = 1
@export var indicator_move_interval: float = 0.3

@onready var indicator: Node2D = %Indicator

func _ready() -> void:
	body_entered.connect(on_body_entered)

	var tween := create_tween().set_loops()
	tween.tween_property(indicator, "position:y", indicator.position.y + indicator_move_offset, 0)
	tween.tween_interval(indicator_move_interval)
	tween.tween_property(indicator, "position:y", indicator.position.y - indicator_move_offset, 0)
	tween.tween_interval(indicator_move_interval)
	tween.play()

func on_body_entered(body: Node2D) -> void:
	if body is Character:
		body.on_pickup(self)
		queue_free()