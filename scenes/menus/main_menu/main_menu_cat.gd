extends AnimatedSprite2D

func _ready() -> void:
	play("intro")
	animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	if animation == "intro":
		play("menu_idle")
