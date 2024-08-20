extends Node2D
class_name PuzzleControl

signal power_changed(new_state: bool)

@export var _powering := true
	
@export var listeners : Array[Powerable]

func _ready() -> void:
	for l in listeners:
		_add_listener(l)
	set_power(_powering)

func _add_listener(powerable: Powerable) -> void:
	power_changed.connect(powerable.set_power)

func set_power(value: bool):
	_powering = value
	power_changed.emit(value)

func is_powered() -> bool:
	return _powering
