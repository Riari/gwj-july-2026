class_name PlayerCharacter extends Character

@export_category("Movement")
@export var move_speed: float = 400.0
@export var jump_speed: float = -400.0

@export_category("Pain")
@export var hurt_disable_input_duration: float = 0.5

@onready var jump_audio: AudioStreamPlayer = %JumpAudio
@onready var hurt_audio: AudioStreamPlayer = %HurtAudio

var hurt_disable_input_timer: float = 0.0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if hurt_disable_input_timer > 0.0:
		hurt_disable_input_timer -= delta
		move_and_slide()
		return
	
	if current_health <= 0:
		move_and_slide()
		return

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		jump_audio.play()

	last_move_direction = Input.get_axis("move_left", "move_right")
	if last_move_direction:
		velocity.x = last_move_direction * move_speed
	else:
		velocity.x = 0.0

	move_and_slide()

func _on_hurt() -> void:
	super._on_hurt()

	hurt_disable_input_timer = hurt_disable_input_duration
	hurt_audio.play()
