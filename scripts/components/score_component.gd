class_name ScoreComponent extends Component

@export var points: int = 0

func on_character_died(instigator: Character) -> void:
	instigator.give_score(points)