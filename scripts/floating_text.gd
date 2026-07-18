class_name FloatingText extends Node2D

@export var y_offset: float = -20.0
@export var duration: float = 1.0

func set_text(text: String) -> void:
	%Label.text = text
	%LabelShadow.text = text

func _ready():
	var tween := create_tween()
	var float_to := global_position.y + y_offset
	tween.tween_property(self, "position:y", float_to, duration / 2.0)
	tween.tween_interval(duration / 2.0)
	tween.play()
	await tween.finished
	queue_free()