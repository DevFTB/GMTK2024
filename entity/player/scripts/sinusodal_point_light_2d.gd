extends PointLight2D

@export var period : float = 1.0
@export var amplitude : float = 1.0
@export var base_amplitude : float = 1.0

var _timer = 0.0

func _physics_process(delta: float) -> void:
	_timer += delta
	energy = amplitude * sin(_timer / period) + base_amplitude
