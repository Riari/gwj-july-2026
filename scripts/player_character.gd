class_name PlayerCharacter extends Character

@export_category("Movement")
@export var move_speed: float = 400.0
@export var jump_speed: float = -400.0

@onready var jump_audio: AudioStreamPlayer = %JumpAudio

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		jump_audio.play()

	last_move_direction = Input.get_axis("move_left", "move_right")
	if last_move_direction:
		velocity.x = last_move_direction * move_speed
	else:
		velocity.x = 0.0

	move_and_slide()
