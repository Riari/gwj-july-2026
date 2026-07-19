class_name Character extends CharacterBody2D

signal on_health_init(health: int)
signal on_hurt(instigator: Character, damage: int)
signal on_healed(amount: int)
signal on_died(instigator: Character)
signal on_scored(score: int)

@export var hurt_cooldown_duration: float = 0.35
@export var floating_text_scene: PackedScene
@export var floating_text_spawn_offset: Vector2 = Vector2(0, 10)

var _components: Array[Component]
var _is_player: bool = false
var _hurt_cooldown_timer: float = 0.0
var _is_dead: bool = false
var _despawn_timer: float = 0.0

func _ready() -> void:
	for node in get_children():
		if node is Component:
			node.init(self)
			_components.push_back(node)
			
			if node is PlayerComponent:
				_is_player = true
	
	for component in _components:
		component.on_components_initialised(_components)
	
	on_died.connect(_on_died)

func _process(delta: float) -> void:
	if _hurt_cooldown_timer > 0.0:
		_hurt_cooldown_timer -= delta
		
		if _hurt_cooldown_timer <= 0.0:
			for component in _components:
				component.on_character_hurt_cooldown_end()
	
	if _is_dead and _despawn_timer > 0.0:
		_despawn_timer -= delta
		if _despawn_timer <= 0.0:
			queue_free()

func get_component(type: Variant) -> Component:
	for component in _components:
		if is_instance_of(component, type):
			return component
	
	return null

func on_hit(instigator: Character, damage: int, knockback_multipler: float = 1.0) -> void:
	if _hurt_cooldown_timer > 0.0:
		return

	for component in _components:
		component.on_character_hurt(instigator, damage)

	_hurt_cooldown_timer = hurt_cooldown_duration
	on_hurt.emit(instigator, damage)

func _on_died(instigator: Character) -> void:
	_despawn_timer = 3.0
	_is_dead = true

	for component in _components:
		component.on_character_died(instigator)

		if component.should_disable_on_death():
			component.disable()
	
	for node in get_children():
		if node is CollisionShape2D:
			node.set_deferred("disabled", true)

func is_player() -> bool:
	return _is_player

func is_dead() -> bool:
	return _is_dead

func on_pickup(pickup: Pickup) -> void:
	for component in _components:
		component.on_character_picked_up(pickup)

func give_score(score: int) -> void:
	if score <= 0 or !_is_player: return
	on_scored.emit(score)
	%ScoreAudio.play()
	spawn_floating_text("+" + str(score))

func spawn_floating_text(text: String) -> void:
	var node: FloatingText = floating_text_scene.instantiate()
	node.set_position(global_position + floating_text_spawn_offset)
	node.set_text(text)
	get_parent().add_child(node)
