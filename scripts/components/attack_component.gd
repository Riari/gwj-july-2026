class_name AttackComponent extends Component

@export var damage: int = 1
@export var cooldown: float = 0.25

@onready var area: Area2D = %AttackArea
@onready var sprite: AnimatedSprite2D = %AttackSprite

var _animation: AnimationComponent
var _area_offset_x: float
var _cooldown_timer: float = 0.0

func _ready() -> void:
	_area_offset_x = area.position.x

func on_components_initialised(_components: Array[Component]) -> void:
	super.on_components_initialised(_components)
	for component in _components:
		if component is AnimationComponent:
			_animation = component

func attack() -> bool:
	if _cooldown_timer > 0.0:
		return false

	_animation.play_anim(AnimationComponent.ANIM_ATTACK)
	sprite.play()
	_cooldown_timer = cooldown
	
	for body in area.get_overlapping_bodies():
		if body is Character:
			body.on_hit(_character, damage)

	return true

func _process(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta

	if !is_zero_approx(_character.velocity.x):
		sprite.flip_h = _character.velocity.x < 0.0
		area.position.x = _area_offset_x if _character.velocity.x > 0.0 else -_area_offset_x
