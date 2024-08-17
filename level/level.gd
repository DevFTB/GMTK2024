extends Node2D


@export var camera_min_x: int
@export var camera_max_x: int
@export var camera_min_y: int
@export var camera_max_y: int

# returns min_x, max_x, min_y, max_y
func get_camera_bounds():
	var tilemap = $Platforms
	var boundary_rect = tilemap.get_used_rect()
	var top_left_corner = boundary_rect.position
	var bottom_right_corner = boundary_rect.end
	#if not camera_max_x:
		#camera_max_x = tilemap.map_to_local()
	
