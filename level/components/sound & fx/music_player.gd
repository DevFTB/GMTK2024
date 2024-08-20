extends Node2D

class_name MusicPlayer

@onready var player: AudioStreamPlayer = $Player

var currently_playing : AudioStream

var queued_track : AudioStream

func _ready():
	_on_player_finished()

func clear_queue():
	queued_track = null
	
func pause() -> void:
	player.stream_paused = true
	
func resume() -> void:
	player.stream_paused = false

func queue_music(track):
	if currently_playing:
		queued_track = track
	else:
		player.set_stream(track)
		currently_playing = track
		player.play()

func _on_player_finished():
	if queued_track:
		currently_playing = queued_track
		player.set_stream(queued_track)
		clear_queue()
	else:
		player.play()
