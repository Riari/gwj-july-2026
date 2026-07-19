class_name AnimationComponent extends Component

const ANIM_IDLE: String = "idle"
const ANIM_LOAF: String = "loaf"
const ANIM_RUN: String = "run"
const ANIM_JUMP: String = "jump"
const ANIM_FALL: String = "fall"
const ANIM_DEAD: String = "dead"
const ANIM_ATTACK: String = "attack"

const AIR_ANIMATIONS: Array = [ANIM_JUMP, ANIM_FALL]

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D

var _movement: MovementComponent
var _anim_locked: bool = false
var _idle_anim: String = ANIM_IDLE

func init(character: Character) -> void:
	super.init(character)
	play_idle_anim()

func on_components_initialised(_components: Array[Component]) -> void:
	for component in _components:
		if component is MovementComponent:
			_movement = component

func on_character_hurt(_instigator: Character, _damage: int, _knockback_multiplier: float = 1.0) -> void:
	play_anim(ANIM_FALL)
	_anim_locked = true

func on_character_hurt_cooldown_end() -> void:
	_anim_locked = false

func on_character_died(_instigator: Character) -> void:
	play_anim(ANIM_DEAD)
	_anim_locked = true

func set_sprite_frames(sprite: SpriteUtils.Type) -> void:
	anim_sprite.sprite_frames = SpriteUtils.sprite_frames[sprite]

func play_idle_anim(anim: String = "") -> void:
	if anim.length() > 0:
		_idle_anim = anim
	anim_sprite.play(_idle_anim)

func play_anim(anim: String) -> void:
	if _anim_locked: return
	anim_sprite.play(anim)
	_idle_anim = ANIM_IDLE

func _process(_delta: float) -> void:
	if _anim_locked: return

	anim_sprite.flip_h = _movement.get_last_move_x_direction() < 0.0

	if anim_sprite.animation == ANIM_DEAD:
		return

	if !_character.is_on_floor():
		if _character.velocity.y > 0.0:
			play_anim(ANIM_FALL)
		if AIR_ANIMATIONS.has(anim_sprite.animation):
			return

	if !is_zero_approx(_character.velocity.x):
		play_anim(ANIM_RUN)
	else:
		play_idle_anim()