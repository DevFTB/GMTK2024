extends Node2D
class_name Powerable

signal power_changed(new_state: bool)

@export var powered := false
@export var inverted_self: bool

func _ready() -> void:
	set_power(powered)

func set_power(incoming_power: bool) -> void:
	powered = incoming_power != inverted_self
	power_changed.emit(powered)
