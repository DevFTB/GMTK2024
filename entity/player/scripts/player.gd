extends GroundedCharacterController
class_name Player

signal size_mode_changed(new_size: SizeMode)
signal killed

enum SizeMode {
	SMALL, NORMAL, BIG
}

@export var size_stats: Dictionary

var size_mode := SizeMode.NORMAL

@onready var colliders := {
	SizeMode.SMALL: $SmallCollider,
	SizeMode.NORMAL: $NormalCollider,
	SizeMode.BIG: $BigCollider,
}

@onready var active_environment_detector: Node2D = $ActiveEnvironmentDetector
@onready var com: Node2D = $COM

func switch_size(size: SizeMode) -> void:
	size_mode = size
	
	# set movement stats
	stats = size_stats[size]
	
	# change colliders
	for s in SizeMode.values():
		var collider : CollisionShape2D = colliders.get(s)
		prints(collider.name, s != size_mode)
		collider.set_deferred("disabled", s != size_mode)

	size_mode_changed.emit(size_mode)

func _physics_process(delta: float) -> void:
	super(delta)
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * stats.mass)

func kill() -> void:
	killed.emit()
