extends AudioStreamPlayer2D

class_name SoundPlayer

@export var footsteps : AudioStream
@export var jump : AudioStream
@export var glide : AudioStream
@export var death : AudioStream
@export var size_up : AudioStream
@export var size_down : AudioStream
@export var fist_smash : AudioStream
@export var interact : AudioStream
@export var chatter : AudioStream


@onready var sound_fx_dict = {
	"footsteps" : footsteps,
	"jump" : jump,
	"glide" : glide,
	"death" : death,
	"size_up": size_up,
	"size_down" : size_down,
	"fist_smash" : fist_smash,
	"interact" : interact,
	"chatter" : chatter
}


func fx_play(track_name):
	var track = sound_fx_dict[track_name]
	print("playing",track_name, track)
	stop()
	set_stream(track)
	play()
