class_name GameState extends Resource

const STATE_NAME: String = "GameState"
const FILE_PATH: String = "res://scripts/resources/game_state.gd"

@export var selected_cat: SpriteUtils.Type = SpriteUtils.Type.CAT_GREY

@export var current_level_time: float = 0.0
@export var last_level_index: int = 0
@export var last_level_score: int = 0
@export var last_level_time: float = 0.0
@export var last_level_medal: MedalUtils.Medal = MedalUtils.Medal.NONE
@export var high_scores: Array[int] = [0, 0, 0, 0, 0, 0, 0]

static func has_game_state() -> bool:
	return GlobalState.has_state(STATE_NAME)

static func get_or_create_state() -> GameState:
	if GlobalState.current == null:
		GlobalState.open()
	return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func get_high_score(level_index: int) -> int:
	var game_state := get_or_create_state()
	return game_state.high_scores[level_index]

static func set_high_score(level_index: int, value: int) -> void:
	var game_state := get_or_create_state()
	game_state.high_scores[level_index] = value
	GlobalState.save()

static func get_selected_cat() -> SpriteUtils.Type:
	var game_state := get_or_create_state()
	return game_state.selected_cat

static func set_selected_cat(value: SpriteUtils.Type) -> void:
	var game_state := get_or_create_state()
	game_state.selected_cat = value
	GlobalState.save()

static func start_level_timer() -> void:
	var game_state := get_or_create_state()
	game_state.current_level_time = 0.0

static func update_level_timer(delta: float) -> void:
	var game_state := get_or_create_state()
	game_state.current_level_time += delta

static func get_current_level_time() -> float:
	var game_state := get_or_create_state()
	return game_state.current_level_time

static func finish_level(level_index: int, level_score: int, time: float, medal: MedalUtils.Medal) -> void:
	var game_state := get_or_create_state()
	game_state.last_level_index = level_index
	game_state.last_level_score = level_score
	game_state.last_level_time = time
	game_state.last_level_medal = medal
	GlobalState.save()

static func get_last_level_index() -> int:
	var game_state := get_or_create_state()
	return game_state.last_level_index

static func get_last_level_score() -> int:
	var game_state := get_or_create_state()
	return game_state.last_level_score

static func get_last_level_time() -> float:
	var game_state := get_or_create_state()
	return game_state.last_level_time

static func get_last_level_medal() -> MedalUtils.Medal:
	var game_state := get_or_create_state()
	return game_state.last_level_medal
