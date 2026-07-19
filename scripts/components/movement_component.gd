class_name MovementComponent extends Component

@export var move_speed: float = 200.0
@export var max_speed: float = 400.0
@export var air_speed_multiplier: float = 0.6
@export var jump_speed: float = -400.0
@export var jump_through_disable_collision_duration: float = 0.2
@export var knockback_vector := Vector2(600.0, 200.0)

var _move_audio: AudioStreamPlayer2D
var _animation: AnimationComponent
var _jump_through_collision_disabled_timer: float = 0.0

var _movement_disabled: bool = false
var _last_move_x_direction: float = 0.0

func _ready() -> void:
	_move_audio = find_child("MoveAudio")

func on_components_initialised(components: Array[Component]) -> void:
	super.on_components_initialised(components)
	for component in components:
		if component is AnimationComponent:
			_animation = component

func on_character_hurt(instigator: Character, _damage: int, knockback_multiplier: float = 1.0) -> void:
	var direction := (global_position - instigator.global_position).normalized()
	var knockback := Vector2.ZERO
	if direction != Vector2.ZERO:
		if is_zero_approx(direction.x):
			direction.x = [-2.0, 2.0].pick_random()
		knockback = Vector2(direction.x * knockback_vector.x, -knockback_vector.y) * knockback_multiplier

	_movement_disabled = true
	_character.velocity += knockback

func on_character_hurt_cooldown_end() -> void:
	_movement_disabled = false

func on_character_died(_instigator: Character) -> void:
	if _move_audio != null:
		_move_audio.stop()

func move(direction: float) -> void:
	if !_is_enabled or _movement_disabled: return

	var speed := move_speed if _character.is_on_floor() else move_speed * air_speed_multiplier
	_character.velocity.x = direction * speed
	if !is_zero_approx(direction):
		_last_move_x_direction = direction
		if _move_audio != null and _move_audio.is_playing() == false:
			_move_audio.play()
	else:
		if _move_audio != null:
			_move_audio.stop()

func get_last_move_x_direction() -> float:
	return _last_move_x_direction

func stop() -> void:
	_character.velocity.x = 0.0

func get_max_jump_height() -> float:
	return (jump_speed * jump_speed) / (2.0 * _character.get_gravity().y)

func jump() -> void:
	if _movement_disabled: return
	_set_jump_through_collision_enabled(false)
	_character.velocity.y = jump_speed

func drop() -> void:
	if _movement_disabled: return
	_set_jump_through_collision_enabled(false)

func _set_jump_through_collision_enabled(enabled: bool) -> void:
	_character.set_collision_mask_value(CollisionLayers.JUMP_THROUGH, enabled)
	if not enabled:
		_jump_through_collision_disabled_timer = jump_through_disable_collision_duration

func _process(delta: float) -> void:
	if _jump_through_collision_disabled_timer > 0.0:
		_jump_through_collision_disabled_timer -= delta

	if _jump_through_collision_disabled_timer <= 0.0 and _character.velocity.y > 0.0:
		_set_jump_through_collision_enabled(true)

func _physics_process(delta: float) -> void:
	if not _character.is_on_floor():
		_character.velocity += _character.get_gravity() * delta

	_character.velocity.x = clamp(_character.velocity.x, -max_speed, max_speed)
	
	if !_character.is_dead():
		_character.velocity.y = clamp(_character.velocity.y, -max_speed, max_speed)

	_character.move_and_slide()
