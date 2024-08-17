extends Node2D

signal change_level(level_name, spawn_point_name)

@export var level_name: String
@export var spawn_point_name: String

@onready var player_interactor: PlayerInteractor = $PlayerInteractor

func _ready() -> void:
	player_interactor.player_entered.connect(_on_player_interactor_player_entered)

func _on_player_interactor_player_entered(player: Player) -> void:
	#print("entered", self, self.name)
	change_level.emit(level_name, spawn_point_name)
