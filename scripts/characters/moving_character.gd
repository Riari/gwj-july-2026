class_name MovingCharacter extends Character

signal on_heal(health_gained: int)

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var attack_area: Area2D = %AttackArea
@onready var attack_sprite: AnimatedSprite2D = %AttackSprite

const ANIM_IDLE: String = "idle"
const ANIM_RUN: String = "run"
const ANIM_JUMP: String = "jump"
const ANIM_FALL: String = "fall"
const ANIM_DEAD: String = "dead"
const ANIM_ATTACK: String = "attack"

var last_move_direction: float = 0.0
var current_anim: String = ANIM_IDLE

var attack_area_x_offset: float

func _ready() -> void:
	super._ready()
	attack_area_x_offset = attack_area.position.x

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
		attack_sprite.flip_h = last_move_direction < 0.0
		if last_move_direction > 0:
			attack_area.position.x = attack_area_x_offset
		else:
			attack_area.position.x = -attack_area_x_offset
	
	global_position = global_position.round()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var collision := get_last_slide_collision()
	if collision:
		var collider := collision.get_collider()
		if collider.is_in_group("ouch"):
			_on_hurt(1, collision.get_normal())

func on_pickup(pickup: Pickup) -> void:
	var heal_amount := pickup.get_heal_value()
	current_health += heal_amount
	var healed_amount := heal_amount
	if current_health > max_health:
		healed_amount = healed_amount - (current_health - max_health)
		current_health = max_health

	on_heal.emit(healed_amount)

func _on_hurt(damage: int, direction: Vector2) -> void:
	super._on_hurt(damage, direction)

	anim_sprite.material.set_shader_parameter("flash_active", true)
	await get_tree().create_timer(hurt_flash_duration).timeout
	anim_sprite.material.set_shader_parameter("flash_active", false)

func _on_died() -> void:
	super._on_died()
	anim_sprite.play(ANIM_DEAD)
	
	set_collision_mask_value(CollisionLayers.WORLD, false)
	set_collision_mask_value(CollisionLayers.JUMP_THROUGH, false)