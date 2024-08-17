extends Node2D
class_name PuzzleControl

signal power_changed(new_state: bool)

@export var powering := true:
	get:
		return _powering
	set(value): set_power(value)
	
@export var listeners : Array[Powerable]

var _powering = false

func _ready() -> void:
	for l in listeners:
		_add_listener(l)

func _add_listener(powerable: Powerable) -> void:
	power_changed.connect(powerable.set_power)

func set_power(value: bool):
	_powering = value
	power_changed.emit(value)
