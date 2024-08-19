extends Camera2D

@export var noise_speed: float = 30.0
@export var shake_magnitude: float = 60.0
@export var decay: float = 3.0

@onready var noise = FastNoiseLite.new()

var _noise_i: float = 0.0
var _strength: float = 0.0

func _ready() -> void:
	noise.seed = randi()
	
func apply_noise_shake(scale:float = 1.0) -> void:
	_strength = shake_magnitude * scale
	
func _process(delta: float) -> void:
	_strength = lerp(_strength, 0.0, decay * delta)
	offset = get_noise_offset(delta, noise_speed, _strength)
	
func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	_noise_i += delta * speed

	return Vector2(
		noise.get_noise_2d(1, _noise_i) * strength,
		noise.get_noise_2d(100, _noise_i) * strength
	)
