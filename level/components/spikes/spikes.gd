extends Node2D

@export var number_of_spikes := 5
@onready var death_area: PlayerInteractor = $DeathArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $DeathArea/CollisionShape2D

func _ready() -> void:
	sprite_2d.region_rect.size.x = number_of_spikes * 32
	collision_shape_2d.shape.size.x  = number_of_spikes * 32
	collision_shape_2d.position.x = number_of_spikes * 32  / 2
	death_area.player_entered.connect(_kill)
	
func _kill(player: Player) -> void:
	player.kill()
