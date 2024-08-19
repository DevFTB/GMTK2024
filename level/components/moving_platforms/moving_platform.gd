extends Powerable

@export var movement_speed : float = 10
@export var autostart := true

var curve : Curve2D

var _progress : float = 0.0
var _reversed : bool = false

var _last_position : Vector2

@onready var static_body_2d: AnimatableBody2D = $StaticBody2D
@onready var path_2d: Path2D = $Path2D
@onready var max_length := path_2d.curve.get_baked_length()

func _ready() -> void:
	curve = path_2d.curve
	if autostart:
		start()

func _physics_process(delta: float) -> void:
	if powered:
		set_progress(_progress + movement_speed * delta)
	
func start() -> void:
	_progress = 0.0
	
func set_progress(value: float) -> void:
	_progress = value
	
	if _progress > max_length:
		_progress = 0.0
		_reversed = not _reversed
	
	var sampled_point = curve.sample_baked(max_length - _progress if _reversed else _progress)
	_last_position = static_body_2d.position
	static_body_2d.position = sampled_point
	
	static_body_2d.constant_linear_velocity = _last_position.direction_to(static_body_2d.position) * movement_speed
