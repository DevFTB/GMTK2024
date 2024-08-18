extends AnimationPlayer

signal transition_tween_completed

@export var sprite_2d: Sprite2D
@export var directional_parameters : Array[String] = ["parameters/move/blend_position", "parameters/jump/blend_position", "parameters/land/blend_position", "parameters/fall/blend_position"]

@onready var player: Player = get_parent()
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var size_change_particles: GPUParticles2D = $"../SizeChangeParticles"

@onready var default_scale := sprite_2d.scale

const scales = {
	Player.SizeMode.SMALL: Vector2(16,16),
	Player.SizeMode.NORMAL: Vector2(32, 48),
	Player.SizeMode.BIG: Vector2(128, 144),
}

func _ready() -> void:
	_bind_signal_to_state(player.jumped, "jump")

func _physics_process(delta: float) -> void:
	for param in directional_parameters:
		animation_tree.set(param, player.last_inputted_direction.x)

func _bind_signal_to_state(player_signal: Signal, state: StringName) -> void:
	player_signal.connect(playback.travel.bind(state))

func transition_to() -> void:
	enable()

	var tween = create_tween()
	
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.25).from(Color.SKY_BLUE)
	tween.tween_callback(size_change_particles.restart)

func transition_from(old_size: Player.SizeMode, new_size: Player.SizeMode) -> void:
	var new_scale = scales[new_size]
	var scale_ratio = new_scale / scales[old_size]
	size_change_particles.scale = scale_ratio
	
	_tween_to_new_scale(scale_ratio)

func _tween_to_new_scale(new_scale: Vector2) -> void:
	print(new_scale)
	var tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(sprite_2d, "scale", new_scale, 0.5).from(default_scale).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite_2d, "modulate", Color.SKY_BLUE, 0.5).from(Color.WHITE)
	
	tween.set_parallel(false)
	tween.tween_callback(transition_tween_completed.emit)
	tween.tween_callback(disable)
	
func enable(show:=true) -> void:
	sprite_2d.scale = default_scale

	if show:
		sprite_2d.show()
		
	animation_tree.active = true
	active = true
	
	playback.travel("idle")
	
func disable() -> void:
	sprite_2d.hide()
	
	animation_tree.active = false
	active = false
