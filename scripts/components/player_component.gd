class_name PlayerComponent extends Component

@export var particle_spawn_offset: Vector2 = Vector2(0, -1.0)
@export var heal_particle: Texture2D
@export var meow_sounds: Array[AudioStream]
@export var attack_sounds: Array[AudioStream]

@onready var jump_audio: AudioStreamPlayer = %JumpAudio
@onready var hurt_audio: AudioStreamPlayer = %HurtAudio
@onready var heal_audio: AudioStreamPlayer = %HealAudio
@onready var attack_audio: AudioStreamPlayer = %AttackAudio
@onready var meow_audio: AudioStreamPlayer = %AttackAudio

@onready var meow_sprite: Sprite2D = %MeowSprite

var _animation: AnimationComponent
var _movement: MovementComponent
var _attack: AttackComponent
var _health: HealthComponent

var _meow_sprite_offset_x: float

var _input_disabled: bool = false

var _particle_scene := load("res://scenes/game_scene/particle.tscn")

func _ready() -> void:
	_meow_sprite_offset_x = meow_sprite.position.x

func init(character: Character) -> void:
	super.init(character)
	meow_sprite.visible = false
	meow_audio.finished.connect(on_meow_end)

func on_components_initialised(components: Array[Component]) -> void:
	super.on_components_initialised(components)
	for component in components:
		if component is AnimationComponent:
			_animation = component
		elif component is MovementComponent:
			_movement = component
		elif component is AttackComponent:
			_attack = component
		elif component is HealthComponent:
			_health = component

	_apply_selected_cat_skin()

func _apply_selected_cat_skin() -> void:
	var cat_sprite := GameState.get_selected_cat()
	_animation.set_sprite_frames(cat_sprite)

func on_character_hurt(_instigator: Character, _damage: int, _knockback_multiplier: float = 1.0) -> void:
	_input_disabled = true
	hurt_audio.play()

func on_character_hurt_cooldown_end() -> void:
	_input_disabled = false

func on_character_picked_up(pickup: Pickup) -> void:
	if pickup.heal_value > 0:
		var particle: Sprite2D = _particle_scene.instantiate()
		particle.set_position(global_position + particle_spawn_offset)
		particle.texture = heal_particle
		_character.get_parent().add_child(particle)
		heal_audio.play()

func _process(_delta: float) -> void:
	if !_is_enabled: return

	if !_input_disabled:
		if Input.is_action_just_pressed("meow"):
			meow()
		
		if Input.is_action_pressed("attack"):
			if _attack.attack():
				attack_audio.stream = attack_sounds.pick_random()
				attack_audio.play()

	if !is_zero_approx(_character.velocity.x):
		meow_sprite.flip_h = _character.velocity.x < 0.0

func _physics_process(_delta: float) -> void:
	if !_is_enabled: return
	
	if !_input_disabled:
		if _character.is_on_floor():
			if Input.is_action_just_pressed("unloaf"):
				_animation.play_idle_anim(AnimationComponent.ANIM_IDLE)
			elif Input.is_action_pressed("loaf") and is_zero_approx(_character.velocity.x):
				_animation.play_idle_anim(AnimationComponent.ANIM_LOAF)
		
			if Input.is_action_pressed("jump"):
				if Input.is_action_pressed("loaf"):
					_movement.drop()
				else:
					_movement.jump()
					_animation.call_deferred("play_anim", AnimationComponent.ANIM_JUMP)
					jump_audio.play()
	
		var move_axis := Input.get_axis("move_left", "move_right")
		_movement.move(move_axis)
		if !is_zero_approx(move_axis):
			meow_sprite.position.x = _meow_sprite_offset_x * move_axis

	var collision := _character.get_last_slide_collision()
	if collision:
		var shape := collision.get_collider_shape()
		if shape != null and shape.is_in_group("ouch"):
			_character.on_hit(collision.get_collider(), 1)

func meow() -> void:
	meow_audio.stream = meow_sounds.pick_random()
	meow_audio.play()
	meow_sprite.visible = true

func on_meow_end() -> void:
	meow_sprite.visible = false
