extends Node2D
@onready var death_area: PlayerInteractor = $DeathArea
@onready var collision_shape_2d: CollisionPolygon2D = $DeathArea/CollisionPolygon2D


func _ready() -> void:
	death_area.player_entered.connect(_kill)
	
func _kill(player: Player) -> void:
	player.kill()
