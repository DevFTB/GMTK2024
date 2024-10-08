extends GroundedCharacterController
class_name Player

signal size_mode_changed(old_size: SizeMode, new_size: SizeMode)
signal killed
signal punched(direction: Vector2)

enum SizeMode {
	SMALL, NORMAL, BIG
}

enum Skill {
	GAUNTLET, GLIDER, DOUBLE_JUMP, SMALL, BIG
}

const SCALES = {
	Player.SizeMode.SMALL: Vector2(16, 16),
	Player.SizeMode.NORMAL: Vector2(32, 48),
	Player.SizeMode.BIG: Vector2(128, 144),
}

const order = [Player.SizeMode.SMALL, Player.SizeMode.NORMAL, Player.SizeMode.BIG]

@export_flags("Gauntlet", "Glider", "Double Jump", "Small", "Big") var starting_skills
@export var size_stats: Dictionary
@export var size_changed_cooldown = 0.5


var size_mode := SizeMode.NORMAL:
	set(value):
		size_mode = value

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

# bit 0:gauntlet, bit 1:glider, bit 2: double_jump
var unlocked_skills: int = 0

var is_walking = false
var currently_playing: String

var is_dead := false
var size_change_cooling := false

var paused = false

func _ready() -> void:
	size_mode = SizeMode.NORMAL
	anim_player_dict[SizeMode.NORMAL].transition_to()
	unlocked_skills = starting_skills

func _input(event: InputEvent) -> void:
	if not paused:
		if event.is_action_pressed("change_size_down"):
			var index = order.find(size_mode)
			var new_index = index - 1
			if new_index >= 0:
				var new_size = order[new_index]
				# only go small if unlocked
				if new_size == SizeMode.SMALL and not unlocked_skills & 2 ** Skill.SMALL:
					return

				print("huh", new_index)

				switch_size(order[new_index])
				

		if event.is_action_pressed("change_size_up"):
			var index = order.find(size_mode)
			var new_index = index + 1
			if new_index < order.size() and not size_change_cooling:
				var new_size = order[new_index]
				# only go small if unlocked
				if new_size == SizeMode.BIG and not unlocked_skills & 2 ** Skill.BIG:
					return
					
				if _check_size(order[new_index]) and not size_change_cooling:
					print("hah", new_index)
					switch_size(order[new_index])
		
		if event.is_action_pressed("punch"):
			if size_mode == SizeMode.BIG:
				punched.emit(last_inputted_direction)

func _physics_process(delta: float) -> void:
	if not is_dead and not paused:
		super(delta)
		if size_mode == SizeMode.BIG:
			for i in get_slide_collision_count():
				var c = get_slide_collision(i)
				var rb = c.get_collider()
				if rb is RigidBody2D:
					var vec = -c.get_normal()
					vec.y = 0
					var force = vec * stats.mass * 100
					print(force)
					#rb.move_and_collide(vec * stats.mass * 3 * delta)
					rb.apply_central_force(force)

func unlock_skill(skill: Skill) -> void:
	unlocked_skills = unlocked_skills | 2 ** skill
	print(unlocked_skills)

func reset() -> void:
	is_dead = false

func kill() -> void:
	if not is_dead:
		is_dead = true
		_frame_velocity = Vector2.ZERO
		velocity = Vector2.ZERO
		killed.emit()

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


	_gliding = false
	size_change_cooling = true
	get_tree().create_timer(size_changed_cooldown).timeout.connect(_allow_size_change)

	active_environment_detector.position = com_dict[size].position
	size_mode_changed.emit(old_size, size_mode)

var _zooming = false
func zoom_whoa(duration: float, destination: Vector2) -> void:
	_frame_velocity = Vector2.ZERO
	if not _zooming:
		var camera: Camera2D = $Camera2D
		var speed = global_position.distance_to(destination) / duration
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(1, 1), duration / 2).from(Vector2(2, 2))
		tween.tween_property(camera, "zoom", Vector2(2, 2), duration / 2).from(Vector2(1, 1))
		tween.tween_callback(func():
								_zooming = false
								_frame_velocity = Vector2(speed, 0)
								)
		var tween2 = create_tween()
		tween2.tween_property(self, "global_position", destination, duration)

		
func _check_size(size: SizeMode) -> bool:
	var dss := get_world_2d().direct_space_state
	
	var params: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas = true
	params.collision_mask = 0b1
	
	var circle := CircleShape2D.new()
	circle.radius = SCALES[size].x / 1.7
	params.shape = circle
		
	#params.shape = collision_shape
	#params.transform = transform
	params.transform = transform.translated(com_dict[size].position)
	
	var result_array = dss.intersect_shape(params, 32)
	#print(result_array)
	var has_vertical_clearance = active_environment_detector.up.get_clearance().length() > SCALES[size].y / 2

	#prints("Size check since %d is greater than 3" % result_array.size(), has_vertical_clearance)
	
	# adjust this as necessary
	return result_array.size() < 4 and has_vertical_clearance

func _can_double_jump() -> bool:
	return stats.can_double_jump and unlocked_skills & 2 ** Skill.DOUBLE_JUMP

func _can_glide() -> bool:
	return stats.can_glide and unlocked_skills & 2 ** Skill.GLIDER

func _allow_size_change() -> void:
	size_change_cooling = false

func set_camera_limits(left, top, right, bottom):
	$Camera2D.limit_top = top
	$Camera2D.limit_left = left
	$Camera2D.limit_right = right
	$Camera2D.limit_bottom = bottom
