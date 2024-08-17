extends Node2D

@onready var spawn_point: Node2D = $SpawnPoint

@onready var player: Player = $Player

func _ready() -> void:
	player.global_position = spawn_point.global_position
	player.killed.connect(_on_player_kill)

func _on_player_kill() -> void:
	player.global_position = spawn_point.global_position
