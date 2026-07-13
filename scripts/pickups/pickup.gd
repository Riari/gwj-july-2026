class_name Pickup extends Area2D

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is Character:
		body.on_pickup(self)
		queue_free()

func get_heal_value() -> int:
	return 1