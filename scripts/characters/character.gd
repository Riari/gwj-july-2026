class_name Character extends CharacterBody2D

signal on_init(health: int)
signal on_heal(health_gained: int)
signal on_hurt(health_lost: int)
signal on_died

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D

@export_category("Pain")
@export var max_health: int = 3
@export var hurt_flash_duration: float = 0.1
@export var hurt_jump_strength: float = 200.0
@export var hurt_knockback_strength: float = 100.0

const ANIM_IDLE: String = "idle"
const ANIM_RUN: String = "run"
const ANIM_JUMP: String = "jump"
const ANIM_FALL: String = "fall"
const ANIM_DEAD: String = "dead"

var last_move_direction: float = 0.0
var current_anim: String = ANIM_IDLE

var current_health: int = max_health

var hurt_direction: Vector2 = Vector2(0, 0)

func _ready() -> void:
	on_init.emit(current_health)

func _process(_delta: float) -> void:
	if current_health <= 0:
		return

	if is_on_floor():
		if last_move_direction:
			anim_sprite.play(ANIM_RUN)
		else:
			anim_sprite.play(ANIM_IDLE)
	else:
		if velocity.y < 0.0:
			anim_sprite.play(ANIM_JUMP)
		else:
			anim_sprite.play(ANIM_FALL)

	if last_move_direction != 0.0:
		anim_sprite.flip_h = last_move_direction < 0.0
	
	global_position = global_position.round()

func _physics_process(_delta: float) -> void:
	var collision := get_last_slide_collision()
	if collision:
		var collider := collision.get_collider()
		if collider.is_in_group("ouch"):
			hurt_direction = collision.get_normal()
			_on_hurt()

	if hurt_direction != Vector2.ZERO:
		velocity += Vector2(hurt_direction.x * hurt_knockback_strength, -hurt_jump_strength)
		hurt_direction = Vector2.ZERO

func _on_hurt() -> void:
	current_health -= 1

	on_hurt.emit(1)
	if current_health <= 0:
		_on_died()

	anim_sprite.material.set_shader_parameter("flash_active", true)
	await get_tree().create_timer(hurt_flash_duration).timeout
	anim_sprite.material.set_shader_parameter("flash_active", false)

func on_pickup(pickup: Pickup) -> void:
	var heal_amount := pickup.get_heal_value()
	current_health += heal_amount
	var healed_amount := heal_amount
	if current_health > max_health:
		healed_amount = healed_amount - (current_health - max_health)
		current_health = max_health

	on_heal.emit(healed_amount)

func _on_died() -> void:
	on_died.emit()
	set_collision_mask_value(1, false)
	anim_sprite.play(ANIM_DEAD)