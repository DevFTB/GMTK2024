extends AnimationPlayer

signal transition_tween_completed
@export var size_mode: Player.SizeMode
@export var sprite_2d: Sprite2D
@export var directional_parameters: Array[String] = ["parameters/move/blend_position", "parameters/jump/blend_position", "parameters/land/blend_position", "parameters/fall/blend_position"]
@export var sound_player: PlayerSound

var is_active: bool:
	get:
		return size_mode == player.size_mode

@onready var player: Player = get_parent()
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var size_change_particles: GPUParticles2D = $"../SizeChangeParticles"

@onready var default_scale := sprite_2d.scale


func _ready() -> void:
	_bind_signal_to_state(player.jumped, "jump")
	_bind_signal_to_state(player.punched, "punch", 1)
	
	player.size_mode_changed.connect(_on_player_size_changed)
	
	player.killed.connect(_on_player_killed)
	
func _physics_process(_delta: float) -> void:
	for param in directional_parameters:
		animation_tree.set(param, player.last_inputted_direction.x)

func _on_player_killed() -> void:
	if is_active:
		sound_player.play("death")
		size_change_particles.emitting = true

func _bind_signal_to_state(player_signal: Signal, state: StringName, unbind: int = 0) -> void:
	if unbind > 0:
		player_signal.connect(playback.travel.bind(state).unbind(unbind))
	else:
		player_signal.connect(playback.travel.bind(state))
		
func transition_to() -> void:
	enable()

	var tween = create_tween()
	
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.25).from(Color.SKY_BLUE)
	tween.tween_callback(size_change_particles.restart)

func transition_from(old_size: Player.SizeMode, new_size: Player.SizeMode) -> void:
	var new_scale = Player.SCALES[new_size]
	var scale_ratio = new_scale / Player.SCALES[old_size]
	size_change_particles.scale = scale_ratio
	
	_tween_to_new_scale(scale_ratio)

func _tween_to_new_scale(new_scale: Vector2) -> void:
	var tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(sprite_2d, "scale", new_scale, 0.5).from(default_scale).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite_2d, "modulate", Color.SKY_BLUE, 0.5).from(Color.WHITE)
	
	tween.set_parallel(false)
	tween.tween_callback(transition_tween_completed.emit)
	tween.tween_callback(disable)
	
func enable(show := true) -> void:
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

func _on_player_size_changed(old_size: Player.SizeMode, new_size: Player.SizeMode) -> void:
	if old_size < new_size:
		sound_player.play("size_down")
	else:
		sound_player.play("size_up")
