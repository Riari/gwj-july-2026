class_name HUD extends Control

@onready var score_label: Label = %ScoreLabel
@onready var score_label_shadow: Label = %ScoreLabelShadow
@onready var timer_label: Label = %TimerLabel
@onready var timer_label_shadow: Label = %TimerLabelShadow

func _process(delta: float) -> void:
	update_timer()

func update_timer() -> void:
	var time := GameState.get_current_level_time()
	var minutes := int(time) / 60
	var seconds := int(time) % 60
	var milliseconds := int((time - int(time)) * 100)
	var time_str := "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	timer_label.text = time_str
	timer_label_shadow.text = time_str

func on_player_health_init(health: int) -> void:
	%HeartBar.init(health)

func on_player_heal(health_gained: int) -> void:
	%HeartBar.modify(health_gained)

func on_player_hurt(health_lost: int) -> void:
	%HeartBar.modify(-health_lost)

func on_player_scored() -> void:
	score_label.text = "Score: " + str(GameState.get_score())
	score_label_shadow.text = "Score: " + str(GameState.get_score())