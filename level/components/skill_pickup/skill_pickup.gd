extends Node2D

@export var skill : Player.Skill

@onready var player_interactor: PlayerInteractor = $PlayerInteractor

func _ready() -> void:
	player_interactor.player_entered.connect(_on_player_entered)

func _on_player_entered(player: Player) -> void:
	player.unlock_skill(skill)
	queue_free()
