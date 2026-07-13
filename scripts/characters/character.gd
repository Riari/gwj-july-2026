class_name Character extends CharacterBody2D

signal on_init(health: int)
signal on_hurt(health_lost: int)
signal on_died

@export_category("Health")
@export var max_health: int = 3
@export var hurt_flash_duration: float = 0.1
@export var hurt_jump_strength: float = 200.0
@export var hurt_knockback_strength: float = 100.0

var current_health: int

func _ready() -> void:
	current_health = max_health
	on_init.emit(current_health)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func hurt(instigator: Node2D, amount: int) -> void:
	_on_hurt(amount, (global_position - instigator.global_position).normalized())

func _on_hurt(damage: int, direction: Vector2) -> void:
	current_health -= damage
	on_hurt.emit(damage)

	if current_health <= 0:
		_on_died()
	
	if has_node("Sprite2D"):
		var sprite := get_node("Sprite2D")
		sprite.material.set_shader_parameter("flash_active", true)
		await get_tree().create_timer(hurt_flash_duration).timeout
		sprite.material.set_shader_parameter("flash_active", false)

	if direction != Vector2.ZERO:
		velocity += Vector2(direction.x * hurt_knockback_strength, -hurt_jump_strength)
		direction = Vector2.ZERO

func _on_died() -> void:
	on_died.emit()
	%CollisionShape2D.set_deferred("disabled", true)
