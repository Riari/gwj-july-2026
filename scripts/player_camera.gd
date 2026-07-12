class_name PlayerCamera extends Camera2D

@export var player: Node2D
@export var follow_threshold_x: float = 20.0
@export var follow_threshold_y: float = 10.0
@export var follow_speed: float = 10.0
@export var centre_epsilon: float = 1.0
@export var centre_adjust: Vector2 = Vector2(0.0, 5.0)

var is_centring_x: bool = false
var is_centring_y: bool = false

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var player_offset: Vector2 = player.global_position - global_position
	var target_position: Vector2 = player.global_position + centre_adjust
	var new_position: Vector2 = global_position

	if not is_centring_x and abs(player_offset.x) > follow_threshold_x:
		is_centring_x = true

	if is_centring_x:
		new_position.x = lerp(global_position.x, target_position.x, follow_speed * delta)

		if abs(new_position.x - target_position.x) <= centre_epsilon:
			new_position.x = target_position.x
			is_centring_x = false

	if not is_centring_y and abs(player_offset.y) > follow_threshold_y:
		is_centring_y = true

	if is_centring_y:
		new_position.y = lerp(global_position.y, target_position.y, follow_speed * delta)

		if abs(new_position.y - target_position.y) <= centre_epsilon:
			new_position.y = target_position.y
			is_centring_y = false

	global_position = new_position.round()