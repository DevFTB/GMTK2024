extends GroundedCharacterController
class_name Player

signal size_mode_changed(old_size:SizeMode, new_size: SizeMode)
signal killed

enum SizeMode {
	SMALL, NORMAL, BIG
}

const order = [Player.SizeMode.SMALL, Player.SizeMode.NORMAL, Player.SizeMode.BIG]

@export var size_stats: Dictionary

var size_mode := SizeMode.NORMAL

var com: Vector2:
	get:
		return com_dict[size_mode].global_position

@onready var colliders := {
	SizeMode.SMALL: $SmallCollider,
	SizeMode.NORMAL: $NormalCollider,
	SizeMode.BIG: $BigCollider,
}

@onready var com_dict := {
	SizeMode.SMALL: $COM/Small,
	SizeMode.NORMAL: $COM/Normal,
	SizeMode.BIG: $COM/Big,
}

@onready var anim_player_dict := {
	SizeMode.SMALL: $SmallAnimationPlayer,
	SizeMode.NORMAL: $NormalAnimationPlayer,
	SizeMode.BIG: $BigAnimationPlayer,
}

@onready var active_environment_detector: Node2D = $ActiveEnvironmentDetector

func _ready() -> void:
	size_mode = SizeMode.NORMAL
	anim_player_dict[SizeMode.NORMAL].transition_to()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_size_down"):
		var index = order.find(size_mode)
		var new_index = index - 1
		if new_index >= 0:
			switch_size(order[new_index])
		
	if event.is_action_pressed("change_size_up"):
		var index = order.find(size_mode)
		var new_index = index + 1
		if new_index < order.size():
			switch_size(order[new_index])
			
func _physics_process(delta: float) -> void:
	super(delta)
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var vec = -c.get_normal()
			vec.y = 0
			c.get_collider().apply_central_impulse(vec * stats.mass)
			
func switch_size(size: SizeMode) -> void:
	var old_player = anim_player_dict[size_mode]
	var old_size = size_mode
	
	size_mode = size
	var new_player = anim_player_dict[size_mode]
		
	old_player.transition_tween_completed.connect(new_player.transition_to, CONNECT_ONE_SHOT)
	old_player.transition_from(old_size, size_mode)

	# set movement stats
	stats = size_stats[size]
	
	# change colliders
	for s in SizeMode.values():
		var collider = colliders.get(s)
		collider.set_deferred("disabled", s != size_mode)

	size_mode_changed.emit(old_size, size_mode)
	
func kill() -> void:
	_frame_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	
	killed.emit()
	
func set_camera_limits(left, top, right, bottom):
	$Camera2D.limit_top = top
	$Camera2D.limit_left = left
	$Camera2D.limit_right = right
	$Camera2D.limit_bottom = bottom
	print(top,left,right,bottom)
