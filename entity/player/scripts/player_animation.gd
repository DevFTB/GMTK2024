extends AnimationPlayer

const BASE_SCALE := Vector2(1,2)
@export var sprite_2d: Sprite2D

@onready var player: Player = get_parent()
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var size_change_particles: GPUParticles2D = $"../SizeChangeParticles"

func _ready() -> void:
	_bind_signal_to_state(player.jumped, "jump")
	player.size_mode_changed.connect(_on_size_mode_changed)

func _physics_process(delta: float) -> void:
	animation_tree.set("parameters/move/blend_position", signi(player.last_inputted_direction.x))

func _bind_signal_to_state(player_signal: Signal, state: StringName) -> void:
	player_signal.connect(playback.travel.bind(state))

func _on_size_mode_changed(new_size: Player.SizeMode) -> void:
	# set sprite and collision_shape size
	var new_scale := Vector2()
	match new_size:
		Player.SizeMode.SMALL:
			new_scale = Vector2(0.5, 0.5) * BASE_SCALE

		Player.SizeMode.NORMAL:
			new_scale = Vector2(2, 2) * BASE_SCALE

		Player.SizeMode.BIG:
			new_scale = Vector2(6, 4) * BASE_SCALE
	size_change_particles.scale = new_scale
	size_change_particles.restart()
	
	sprite_2d.scale = new_scale
