extends Node2D
class_name Powerable

signal power_changed(new_state: bool)

@export var powered := false
@export var inverted_self: bool

var is_controlled : bool = false

func _ready() -> void:
	set_power(powered, false)

func set_power(incoming_power: bool, authority:=true) -> void:
	if (is_controlled and authority) or not is_controlled:
		powered = incoming_power != inverted_self
		power_changed.emit(powered)
