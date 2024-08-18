extends RayCast2D

@onready var environment_detector: RayCast2D = $EnvironmentDetector

@onready var direction : Vector2 = target_position.normalized()

func get_clearance() -> Vector2:
	if environment_detector.is_colliding():
		return environment_detector.get_collision_point() - global_position
	else:
		return Vector2.INF
		
func is_active_colliding() -> bool:
	if is_colliding() and environment_detector.is_colliding():
		var vec := environment_detector.get_collision_point() - get_collision_point()
		vec = vec.rotated(-direction.angle())
		return vec.x > 0
			
	return false
