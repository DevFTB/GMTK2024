extends Node2D
class_name Level

@export var camera_min_x: int
@export var camera_max_x: int
@export var camera_min_y: int
@export var camera_max_y: int

var level_transisitons:
	get = get_level_transitions
		
func _ready() -> void:
	if not $LevelTransitions:
		push_error("Level has no transitions node")

# returns min_x, max_x, min_y, max_y
func get_camera_bounds():
	var tilemap = $Platforms
	var boundary_rect = tilemap.get_used_rect()
	var top_left_corner = boundary_rect.position
	var bottom_right_corner = boundary_rect.end
	#if not camera_max_x:
		#camera_max_x = tilemap.map_to_local()
	
func get_level_transitions() -> Array:
	var level_transitions := $LevelTransitions
	if level_transisitons:
		return level_transisitons.get_children()
	else:
		return []
