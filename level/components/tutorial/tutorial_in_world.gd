extends Node2D

@onready var control_gui: Control = $ControlGUI
@onready var transition: AnimationPlayer = $Transition


func _on_player_detector_body_entered(_area):
	transition.play("fade_in")


func _on_player_detector_body_exited(_area):
	transition.play("fade_out")

func fade_in() -> void:
	transition.play("fade_in")

func fade_out() -> void:
	transition.play("fade_out")
