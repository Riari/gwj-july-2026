class_name PlayerCharacter extends Character

@export_category("Movement")
@export var move_speed: float = 400.0
@export var jump_speed: float = -400.0

@export_category("Pain")
@export var hurt_disable_input_duration: float = 0.5

@export_category("Particles")
@export var particle_spawn_offset: Vector2 = Vector2(0, -1.0)
@export var heal_particle: Texture2D

@onready var jump_audio: AudioStreamPlayer = %JumpAudio
@onready var hurt_audio: AudioStreamPlayer = %HurtAudio
@onready var heal_audio: AudioStreamPlayer = %HealAudio

var particle_scene := load("res://scenes/game_scene/particle.tscn")

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

func on_pickup(pickup: Pickup) -> void:
	super.on_pickup(pickup)
	
	if pickup.get_heal_value() > 0:
		heal_audio.play()
		var particle: Sprite2D = particle_scene.instantiate()
		particle.set_position(global_position + particle_spawn_offset)
		particle.texture = heal_particle
		get_tree().current_scene.add_child(particle)

func _on_hurt() -> void:
	super._on_hurt()

	hurt_disable_input_timer = hurt_disable_input_duration
	hurt_audio.play()
