extends Panel

@export var player: Player

@onready var gliding_label: Label = $VBoxContainer/GlidingLabel
@onready var frame_input_label: Label = $VBoxContainer/FrameInputLabel

func _process(_delta: float) -> void:
	gliding_label.text = str(player._gliding)
	frame_input_label.text = str(player._frame_input.jump_down, " ", player._frame_input.jump_held)
