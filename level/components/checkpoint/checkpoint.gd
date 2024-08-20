extends Node2D
class_name Checkpoint

signal checkpoint_reached

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if not is_in_group("spawn_point"):
		add_to_group("spawn_point")
	
	player_interactor.player_entered.connect(checkpoint_reached.emit.bind(global_position).unbind(1))
	checkpoint_reached.connect(sprite_2d.set_state.bind("on").unbind(1))
	checkpoint_reached.connect(animation_player.play.bind("pulse").unbind(1))

func disable() -> void:
	sprite_2d.set_state("off")
	animation_player.stop()
