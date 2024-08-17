extends AnimationPlayer

@onready var player: GroundedCharacterController = get_parent()
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
	_bind_signal_to_state(player.jumped, "jump")

func _physics_process(delta: float) -> void:
	animation_tree.set("parameters/move/blend_position", signi(player.last_inputted_direction.x))

func _bind_signal_to_state(player_signal: Signal, state: StringName) -> void:
	player_signal.connect(playback.travel.bind(state))
