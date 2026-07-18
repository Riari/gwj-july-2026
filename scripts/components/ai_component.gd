class_name AIComponent extends Component

@export var wander_interval: Array[float] = [1.0, 3.0]
@export var idle_interval: Array[float] = [1.0, 3.0]
@export var can_attack: bool = true

var wander_timer: float = 0.0
var idle_timer: float = 0.0