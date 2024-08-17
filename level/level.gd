extends Node2D


@export var camera_min_x: int
@export var camera_max_x: int
@export var camera_min_y: int
@export var camera_max_y: int

func get_camera_bounds() -> Dictionary:
	var tilemap = $Platforms
	var boundary_rect = tilemap.get_used_rect()
	var top_left_corner = boundary_rect.position
	var bottom_right_corner = boundary_rect.end
	if not camera_min_x:
		camera_min_x = tilemap.map_to_local(top_left_corner).x
	if not camera_max_x:
		camera_max_x = tilemap.map_to_local(bottom_right_corner).x
	if not camera_min_y:
		camera_min_y = tilemap.map_to_local(top_left_corner).y
	if not camera_max_y:
		camera_max_y = tilemap.map_to_local(bottom_right_corner).y
		
	return {
		"left": camera_min_x,
		"right": camera_max_x,
		"top": camera_min_y,
		"bottom": camera_max_y
	}
