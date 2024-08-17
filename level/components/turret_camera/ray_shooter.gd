extends Node2D
class_name VisualRayShooter
@export var ray_color: Color
@export var ray_width: int = 4
@export var ray_length: float = 16
@export var default_duration := 0.4

class Ray:
	var origin: Vector2
	var destination: Vector2

	var ratio := 0.0

	func _init(p_origin: Vector2, p_destination: Vector2) -> void:
		origin = p_origin
		destination = p_destination
		
		ratio = 0.0
		
	func draw(canvas: Node2D, length : float, color : Color, width := 1.0) -> void:
		var dir := origin.direction_to(destination)

		var start : Vector2 = lerp(origin, destination - dir * length, ratio)
		var end : Vector2 = lerp(origin + dir * length, destination, ratio)

		canvas.draw_line(start, end, color, width)

var rays: Array[Ray] = []

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for ray in rays:
		ray.draw(self, ray_length, ray_color, ray_width)

func shoot_ray(origin: Vector2, destination: Vector2, duration: float = default_duration) -> void:
	var new_ray := Ray.new(origin, destination)
	rays.append(new_ray)

	var tween := create_tween()
	tween.tween_property(new_ray, "ratio", 1.0, duration)
	tween.tween_callback(rays.erase.bind(new_ray))
