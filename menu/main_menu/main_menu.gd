extends Control

@export var load_on_play_scene : PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("opening")
	
	%PlayButton.pressed.connect(_on_play_pressed)
	%ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_play_pressed() -> void:
	animation_player.play("power_on")
	animation_player.animation_finished.connect(get_tree().change_scene_to_packed.bind(load_on_play_scene).unbind(1), CONNECT_ONE_SHOT)

func _on_exit_button_pressed() -> void:
	animation_player.play_backwards("opening")
	animation_player.speed_scale = 3.0
	await animation_player.animation_finished
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
