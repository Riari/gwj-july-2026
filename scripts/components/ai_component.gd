class_name AIComponent extends Component

@export var wander_interval: Array[float] = [1.0, 3.0]
@export var idle_interval: Array[float] = [0.5, 1.0]
@export var can_jump: bool = true
@export var min_jump_interval: float = 2.0
@export var jump_chance: float = 0.5
@export var can_attack: bool = true
@export var attack_radius: float = 20.0
@export var aggro_radius: float = 200.0

enum State {
	WANDER,
	IDLE,
	ATTACKING
}

var _animation: AnimationComponent
var _movement: MovementComponent
var _attack: AttackComponent

var _directions: Array[float] = [-1.0, 1.0]
var _passive_states: Array[State] = [State.WANDER, State.IDLE]

var _timer: float = 1.0
var _jump_timer: float = 0.0
var _state: State = State.WANDER
var _move_direction: float = 0.0

var _player: Character

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		_player = node
		break

func _physics_process(delta: float) -> void:
	if !_is_enabled or !_player: return
	
	var distance_to_player: float = _character.global_position.distance_to(_player.global_position)
	if can_attack and distance_to_player < aggro_radius:
		_state = State.ATTACKING
		_move_direction = _character.global_position.direction_to(_player.global_position).x
	elif _state == State.ATTACKING:
		_choose_random_state()
	else:
		if _timer > 0.0:
			_timer -= delta
			if _timer <= 0.0:
				_choose_random_state()

		if _character.is_on_wall():
			_move_direction = -_move_direction
	
	var jumping := false
	if can_jump:
		jumping = _process_jump(delta)

	if !jumping and _character.is_on_floor():
		if _state == State.ATTACKING and distance_to_player < attack_radius:
			_movement.stop()
			_attack.attack()
			return

		_movement.move(_move_direction)

func on_components_initialised(components: Array[Component]) -> void:
	super.on_components_initialised(components)

	for component in components:
		if component is AnimationComponent:
			_animation = component
		elif component is MovementComponent:
			_movement = component
		elif component is AttackComponent:
			_attack = component

	_choose_random_state()

func _process_jump(delta: float) -> bool:
	if _state == State.ATTACKING:
		var distance := _character.global_position - _player.global_position
		if abs(distance.x) > attack_radius:
			if distance.y > attack_radius and _can_jump_to_platform():
				_movement.jump()
				return true
			elif distance.y < -attack_radius:
				_movement.drop()
				return true
		return false

	if _jump_timer > 0.0:
		_jump_timer -= delta
	
	if _jump_timer <= 0.0:
		_jump_timer = min_jump_interval

		if randf() > jump_chance:
			return false
		
		if _can_jump_to_platform():
			_movement.jump()
		else:
			_movement.drop()

		return true

	return false

func _can_jump_to_platform() -> bool:
	var platform_mask := 1 << (CollisionLayers.JUMP_THROUGH - 1)
	var max_jump_height := _movement.get_max_jump_height()
	var space_state := _character.get_world_2d().direct_space_state
	var from := _character.global_position
	var to := from + Vector2(0, -max_jump_height)

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = platform_mask
	query.hit_from_inside = false

	var result := space_state.intersect_ray(query)
	return !result.is_empty()

func _choose_random_state() -> void:
	_state = _passive_states.pick_random()

	match _state:
		State.WANDER:
			_timer = randf_range(wander_interval[0], wander_interval[1])
			_move_direction = _directions.pick_random()
		State.IDLE:
			_timer = randf_range(wander_interval[0], wander_interval[1])
			_move_direction = 0.0
		State.ATTACKING:
			pass
