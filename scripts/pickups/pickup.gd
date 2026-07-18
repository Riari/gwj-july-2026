class_name Pickup extends Area2D

@export var heal_value: int = 1

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is Character:
		body.on_pickup(self)
		queue_free()