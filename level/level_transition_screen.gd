extends Control

const ALPHA_WHITE = Color(Color.WHITE, 0.0)

signal fade_out_completed

@export var transition_time : float = 1.0

var _tween : Tween

func fade_out() -> void:
	_tween = create_tween()
	_tween.tween_property(self, "modulate", Color.WHITE, transition_time).from(ALPHA_WHITE).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(fade_out_completed.emit)
	
	show()
	
func fade_in() -> void:
	_tween = create_tween()
	_tween.tween_property(self, "modulate", ALPHA_WHITE, transition_time).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(hide)
