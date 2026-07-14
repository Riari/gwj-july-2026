class_name GameState extends Resource

const STATE_NAME: String = "GameState"
const FILE_PATH: String = "res://scripts/resources/game_state.gd"

@export var score: int
@export var high_score: int

static func has_game_state() -> bool:
	return GlobalState.has_state(STATE_NAME)

static func get_or_create_state() -> GameState:
	if GlobalState.current == null:
		GlobalState.open()
	return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func get_score() -> int:
	var game_state := get_or_create_state()
	return game_state.score

static func get_high_score() -> int:
	var game_state := get_or_create_state()
	return game_state.high_score

static func reset_score() -> void:
	var game_state := get_or_create_state()
	game_state.score = 0
	GlobalState.save()

static func add_score(amount: int) -> void:
	var game_state := get_or_create_state()
	game_state.score += amount
	if game_state.score > game_state.high_score:
		game_state.high_score = game_state.score
	GlobalState.save()

static func set_score(value: int) -> void:
	var game_state := get_or_create_state()
	game_state.score = value
	GlobalState.save()

static func set_high_score(value: int) -> void:
	var game_state := get_or_create_state()
	game_state.high_score = value
	GlobalState.save()
