extends Node2D

@onready var death_area: PlayerInteractor = $DeathArea

func _ready() -> void:
	death_area.player_entered.connect(_kill)
	
func _kill(player: Player) -> void:
	player.kill()
