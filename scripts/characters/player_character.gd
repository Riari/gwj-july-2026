class_name PlayerCharacter extends MovingCharacter

@export_category("Movement")
@export var move_speed: float = 400.0
@export var jump_speed: float = -400.0
@export var jump_through_disable_collision_duration: float = 0.2

@export_category("Attack")
@export var attack_cooldown: float = 0.25
@export var attack_sounds: Array[AudioStream]

@export_category("Health")
@export var hurt_disable_input_duration: float = 0.5

@export_category("Particles")
@export var particle_spawn_offset: Vector2 = Vector2(0, -1.0)
@export var heal_particle: Texture2D

@export_category("Audio")
@export var meow_sounds: Array[AudioStream]

@onready var jump_audio: AudioStreamPlayer = %JumpAudio
@onready var hurt_audio: AudioStreamPlayer = %HurtAudio
@onready var heal_audio: AudioStreamPlayer = %HealAudio
@onready var attack_audio: AudioStreamPlayer = %AttackAudio
@onready var meow_audio: AudioStreamPlayer = %AttackAudio

@onready var meow_sprite: Sprite2D = %MeowSprite

var particle_scene := load("res://scenes/game_scene/particle.tscn")

var attack_cooldown_timer: float = 0.0
var hurt_disable_input_timer: float = 0.0

var jump_through_collision_disabled_timer: float = 0.0

func _ready() -> void:
	super._ready()
	meow_sprite.visible = false
	meow_audio.finished.connect(on_meow_end)

func _process(delta: float) -> void:
	if attack_cooldown_timer > 0.0:
		global_position = global_position.round()
		return
	
	if Input.is_action_just_pressed("meow"):
		meow()

	if last_move_direction != 0.0:
		meow_sprite.flip_h = last_move_direction < 0.0
	
	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if hurt_disable_input_timer > 0.0:
		hurt_disable_input_timer -= delta
		move_and_slide()
		return
	
	if current_health <= 0:
		move_and_slide()
		return
		
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
	
	if Input.is_action_just_pressed("attack") and attack_cooldown_timer <= 0.0:
		_on_attack()
		lock_anim = false
		
	if Input.is_action_pressed("move_down") and is_on_floor():
		anim_sprite.play(ANIM_LOAF)
		lock_anim = true

	if jump_through_collision_disabled_timer > 0.0:
		jump_through_collision_disabled_timer -= delta

	if jump_through_collision_disabled_timer <= 0.0 and velocity.y > 0.0:
		_set_jump_through_collision_enabled(true)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		_set_jump_through_collision_enabled(false)

		if !Input.is_action_pressed("move_down"):
			velocity.y = jump_speed
			jump_audio.play()
			lock_anim = false

	last_move_direction = Input.get_axis("move_left", "move_right")
	if last_move_direction:
		velocity.x = last_move_direction * move_speed
		lock_anim = false
	else:
		velocity.x = 0.0
	
	if !velocity.is_zero_approx():
		lock_anim = false

	move_and_slide()

func meow() -> void:
	meow_audio.stream = meow_sounds.pick_random()
	meow_audio.play()
	meow_sprite.visible = true

func on_meow_end() -> void:
	meow_sprite.visible = false

func _set_jump_through_collision_enabled(enabled: bool) -> void:
	set_collision_mask_value(CollisionLayers.JUMP_THROUGH, enabled)
	if not enabled:
		jump_through_collision_disabled_timer = jump_through_disable_collision_duration

func on_pickup(pickup: Pickup) -> void:
	super.on_pickup(pickup)
	
	if pickup.get_heal_value() > 0:
		heal_audio.play()
		var particle: Sprite2D = particle_scene.instantiate()
		particle.set_position(global_position + particle_spawn_offset)
		particle.texture = heal_particle
		get_tree().current_scene.add_child(particle)

func _on_attack() -> void:
	anim_sprite.play(ANIM_ATTACK)
	attack_sprite.play()
	attack_audio.stream = attack_sounds.pick_random()
	attack_audio.play()
	attack_cooldown_timer = attack_cooldown
	
	for body in attack_area.get_overlapping_bodies():
		if body is Character:
			body.hurt(self, 1)

func _on_hurt(damage: int, direction: Vector2) -> void:
	super._on_hurt(damage, direction)

	hurt_disable_input_timer = hurt_disable_input_duration
	hurt_audio.play()
