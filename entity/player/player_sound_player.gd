extends AudioStreamPlayer2D
class_name SizeSoundPlayer

@export var footsteps : AudioStream
@export var jump : AudioStream
@export var glide : AudioStream #not connected
@export var death : AudioStream #not connected
@export var size_up : AudioStream
@export var size_down : AudioStream 
@export var fist_smash : AudioStream #not connected
@export var interact : AudioStream #not connected
@export var chatter : AudioStream #not connected

@onready var sound_fx_dict = {
	"move" : footsteps,
	"jump" : jump,
	"glide" : glide,
	"death" : death,
	"size_up": size_up,
	"size_down" : size_down,
	"fist_smash" : fist_smash,
	"interact" : interact,
	"chatter" : chatter
}

var current_playing = ""

func _ready() -> void:
	finished.connect(_on_finished)

func _on_finished() -> void:
	current_playing = ""

func fx_play(track_name: String) -> void:
	if sound_fx_dict.has(track_name):
		var track = sound_fx_dict[track_name]
		print("playing",track_name, track)
		stop()
		
		set_stream(track)
		current_playing = track_name
		
		play()
	else:
		stop()
