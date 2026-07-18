class_name Component extends Node2D

var _character: Character
var _is_enabled: bool = false

func init(character: Character) -> void:
	print(character.get_name() + ": Initialising " + get_name())
	_character = character

func on_components_initialised(_components: Array[Component]) -> void:
	_is_enabled = true

func should_disable_on_death() -> bool:
	return true

func enable() -> void:
	_is_enabled = true

func disable() -> void:
	_is_enabled = false

func on_character_hurt(_instigator: Character, _damage: int) -> void:
	return

func on_character_hurt_cooldown_end() -> void:
	return

func on_character_died(_instigator: Character) -> void:
	return

func on_character_picked_up(_pickup: Pickup) -> void:
	return