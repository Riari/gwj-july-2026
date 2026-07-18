class_name AIComponent extends Component

@export var wander_interval: Array[float] = [1.0, 3.0]
@export var idle_interval: Array[float] = [0.5, 1.0]
@export var can_attack: bool = true

enum State {
	WANDER,
	IDLE,
	ATTACKING
}

var _movement: MovementComponent

var _directions: Array[float] = [-1.0, 1.0]
var _passive_states: Array[State] = [State.WANDER, State.IDLE]

var _timer: float = 1.0
var _state: State = State.WANDER
var _move_direction: float = 0.0

func _physics_process(delta: float) -> void:
	if !_is_enabled: return

	if _timer > 0.0:
		_timer -= delta
		if _timer <= 0.0:
			choose_next_state()

	if _character.is_on_wall():
		_move_direction = -_move_direction

	_movement.move(_move_direction)

func on_components_initialised(components: Array[Component]) -> void:
	super.on_components_initialised(components)

	for component in components:
		if component is MovementComponent:
			_movement = component

	choose_next_state()

func choose_next_state() -> void:
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