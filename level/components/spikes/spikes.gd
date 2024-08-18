extends Node2D

@export var number_of_spikes := 5
@onready var death_area: PlayerInteractor = $DeathArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var triangle_collision_polygon: CollisionPolygon2D = $DeathArea/CollisionPolygon2D

func _ready() -> void:
	sprite_2d.region_rect.size.x = number_of_spikes * 32
	
	for i in number_of_spikes:
		var new_polygon = triangle_collision_polygon.duplicate()
		new_polygon.position = Vector2(i * 32, 0)
		death_area.add_child(new_polygon)
		
	death_area.player_entered.connect(_kill)
	
func _kill(player: Player) -> void:
	player.kill()
