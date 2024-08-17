extends Node2D

signal power_changed(new_state: bool)

@onready var player_interactor: PlayerInteractor = $PlayerInteractor

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_interactor.has_player:
			powering = not powering
