class_name HealthComponent extends Component

@export var max_health: int = 3
@export var hurt_sprite: Node2D
@export var hurt_flash_duration: float = 0.1

var _current_health: int

func init(character: Character) -> void:
	super.init(character)
	_current_health = max_health
	_character.on_health_init.emit(_current_health)

func on_character_hurt(instigator: Character, damage: int, _knockback_multiplier: float = 1.0) -> void:
	_current_health -= damage

	if _current_health <= 0:
		_on_died(instigator)

	hurt_sprite.material.set_shader_parameter("flash_active", true)
	await get_tree().create_timer(hurt_flash_duration).timeout
	hurt_sprite.material.set_shader_parameter("flash_active", false)

func on_character_picked_up(pickup: Pickup) -> void:
	_on_heal(pickup.heal_value)

func _on_heal(amount: int) -> void:
	_current_health += amount
	_character.on_healed.emit(amount)

func _on_died(instigator: Character) -> void:
	_character.on_died.emit(instigator)
