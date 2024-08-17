extends Node2D
class_name PuzzleControl

signal power_changed(new_state: bool)

@export var powering := true:
	set(value):
		powering = value
		power_changed.emit(value)

@export var listeners : Array[Powerable]

func _ready() -> void:
	for l in listeners:
		_add_listener(l)

func _add_listener(powerable: Powerable) -> void:
	power_changed.connect(powerable.set_power)
