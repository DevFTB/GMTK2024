extends Node2D

@onready var up: RayCast2D = $Up
@onready var down: RayCast2D = $Down
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right

func is_active_colliding(dir: Vector2) -> bool:
	dir = dir.normalized()
	dir.x = roundi(dir.x)
	dir.y = roundi(dir.y)
	
	match dir:
		Vector2.UP:
			return up.is_active_colliding()
		Vector2.DOWN:
			return down.is_active_colliding()
		Vector2.LEFT:
			return left.is_active_colliding()
		Vector2.RIGHT:
			return right.is_active_colliding()
		_:
			return false
