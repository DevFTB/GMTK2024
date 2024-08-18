extends Node2D

@onready var player_detector = $PlayerDetector
@onready var control_gui: HBoxContainer = $ControlGUI
@onready var transition: AnimationPlayer = $Transition


func _on_player_detector_body_entered(area):
	print("enter text area")
	transition.play("fade_in")


func _on_player_detector_body_exited(area):
	transition.play("fade_out")
