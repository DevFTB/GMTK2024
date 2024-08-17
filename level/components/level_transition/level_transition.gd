extends Node2D

signal change_level(level, spawn_point)

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@export var level: String
@export var spawn_point: String

func _on_player_interactor_player_entered(player: Player) -> void:
	change_level.emit(level, spawn_point)
