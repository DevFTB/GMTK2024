extends GroundedCharacterController
class_name Player

signal size_mode_changed(new_size: SizeMode)

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
