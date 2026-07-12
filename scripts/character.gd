class_name Character extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D

const ANIM_IDLE: String = "idle"
const ANIM_RUN: String = "run"
const ANIM_JUMP: String = "jump"
const ANIM_FALL: String = "fall"

var last_move_direction: float = 0.0
var current_anim: String = ANIM_IDLE

func _process(delta: float) -> void:
	if is_on_floor():
		if last_move_direction:
			anim_sprite.play(ANIM_RUN)
		else:
			anim_sprite.play(ANIM_IDLE)
	else:
		if velocity.y < 0.0:
			anim_sprite.play(ANIM_JUMP)
		else:
			anim_sprite.play(ANIM_FALL)

	if last_move_direction != 0.0:
		anim_sprite.flip_h = last_move_direction < 0.0
	
	global_position = global_position.round()