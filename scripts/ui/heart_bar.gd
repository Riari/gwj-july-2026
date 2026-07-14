class_name HeartBar extends HFlowContainer

signal hearts_depleted

@export var heart_filled: Texture
@export var heart_empty: Texture

var total_hearts: int
var current_hearts: int

func init(amount: int):
	for i in range(amount):
		var heart := TextureRect.new()
		heart.texture = heart_filled
		add_child(heart)

	total_hearts = amount
	current_hearts = amount

func modify(amount: int):
	current_hearts += amount
	if current_hearts > total_hearts:
		current_hearts = total_hearts

	update()
	if current_hearts <= 0:
		hearts_depleted.emit()

func update():
	for i in get_child_count():
		if current_hearts > i:
			get_child(i).texture = heart_filled
		else:
			get_child(i).texture = heart_empty