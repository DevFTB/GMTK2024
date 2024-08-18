extends AnimationPlayer

const BASE_SCALE := Vector2(1,2)
@export var sprite_2d: Sprite2D

@onready var player: Player = get_parent()
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var size_change_particles: GPUParticles2D = $"../SizeChangeParticles"

var directional_parameters : Array[String] = ["parameters/move/blend_position", "parameters/jump/blend_position", "parameters/land/blend_position", "parameters/fall/blend_position"]

func _ready() -> void:
	_bind_signal_to_state(player.jumped, "jump")
	player.size_mode_changed.connect(_on_size_mode_changed)

func _physics_process(delta: float) -> void:
	for param in directional_parameters:
		animation_tree.set(param, signi(player.last_inputted_direction.x))

func _bind_signal_to_state(player_signal: Signal, state: StringName) -> void:
	player_signal.connect(playback.travel.bind(state))

func _on_size_mode_changed(new_size: Player.SizeMode) -> void:
	# set sprite and collision_shape size
	var new_scale := Vector2()
	match new_size:
		Player.SizeMode.SMALL:
			new_scale = Vector2(0.5, 0.25) 

		Player.SizeMode.NORMAL:
			new_scale = Vector2(1, 1)

		Player.SizeMode.BIG:
			new_scale = Vector2(4, 3)
	size_change_particles.scale = new_scale
	size_change_particles.restart()
	
	_tween_to_new_scale(new_scale)

func _tween_to_new_scale(new_scale) -> void:
	var tween = create_tween()
	tween.tween_property(sprite_2d, "scale", new_scale, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
