extends Node2D
class_name PlayerSound

@export var player: Player
@export var max_queue_size: int = 1

var active_player: SizeSoundPlayer:
	get:
		return sound_players[player.size_mode]

var currently_playing: String 
var is_looping : bool = false
var queue : Array[AudioQueueItem] = []

@onready var sound_players = {
	Player.SizeMode.SMALL: $SmallSoundPlayer,
	Player.SizeMode.NORMAL: $NormalSoundPlayer,
	Player.SizeMode.BIG: $BigSoundPlayer
}

func _ready() -> void:
	for sp in sound_players.values():
		sp.finished.connect(_pop_queue)

func play(key: String, force:=false, is_loop:=false) -> void:
	prints(key, force, is_loop, " currently : ", currently_playing)
	if currently_playing != key:
		if active_player.playing:
			if force or is_looping:
				print("played it on top")
				active_player.fx_play(key)
				is_looping = is_loop
			else:
				if queue.size () < max_queue_size:
					print("queued it")

					queue.push_back(AudioQueueItem.new(key, is_loop))

		else:
			print("played it")

			active_player.fx_play(key)
			is_looping = is_loop
	else:
		print("play nothing")
		_pop_queue()

func _pop_queue() -> void:
	if queue.size() > 0:
		var next : AudioQueueItem = queue.pop_front()
		play(next.key, false, next.is_loop)
	else:
		currently_playing = ""
		active_player.stop()
		
class AudioQueueItem:
	var is_loop : bool = false
	var key: String = ""
	
	func _init(p_key: String, p_is_loop: bool = false) -> void:
		key = p_key
		is_loop = p_is_loop
