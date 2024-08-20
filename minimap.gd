extends Control

@export var world : World
@onready var player_icon: TextureRect = $MinimapTexture/PlayerIcon

func open() -> void:
	var child_rect = find_child(world.level.level_name)
	var center = child_rect.position + child_rect.size / 2
	player_icon.position = center - player_icon.size / 2
	show()
	
