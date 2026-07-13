extends Sprite2D

@export var y_offset: float = -20.0
@export var duration: float = 0.6

func _ready():
	var tween := create_tween()
	var float_to := global_position.y + y_offset
	tween.tween_property(self, "position:y", float_to, duration)
	tween.play()
	await tween.finished
	queue_free()