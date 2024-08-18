extends RayCast2D

@onready var environment_detector: RayCast2D = $EnvironmentDetector

@onready var direction : Vector2 = target_position.normalized()

func is_active_colliding() -> bool:
	if is_colliding() and environment_detector.is_colliding():
		var vec := environment_detector.get_collision_point() - get_collision_point()
		vec = vec.rotated(-direction.angle())
		return vec.x > 0
			
	return false
