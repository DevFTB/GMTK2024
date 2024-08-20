extends Node2D
class_name PlayerSound

@export var player: Player
@export var max_queue_size: int = 1

var active_player: SizeSoundPlayer:
	get:
		return sound_players[player.size_mode]

var currently_playing: String
var is_looping: bool = false
var queue: Array[AudioQueueItem] = []

@onready var sound_players = {
	Player.SizeMode.SMALL: $SmallSoundPlayer,
	Player.SizeMode.NORMAL: $NormalSoundPlayer,
	Player.SizeMode.BIG: $BigSoundPlayer
}

func _ready() -> void:
	for sp in sound_players.values():
		sp.finished.connect(_pop_queue)
		
	player.size_mode_changed.connect(_on_player_size_changed)

func _on_player_size_changed(old_size: Player.SizeMode, _new_size: Player.SizeMode) -> void:
	var old_player = sound_players[old_size]
	old_player.stop()

func play(key: String, force := false, is_loop := false) -> void:
	#prints(key, force, is_loop, " currently : ", currently_playing)
	if currently_playing != key:
		if active_player.playing:
			if force or is_looping:
				active_player.fx_play(key)
				is_looping = is_loop
			else:
				if queue.size() < max_queue_size:

					queue.push_back(AudioQueueItem.new(key, is_loop))

		else:

			active_player.fx_play(key)
			is_looping = is_loop
	else:
		_pop_queue()

func _pop_queue() -> void:
	if queue.size() > 0:
		var next: AudioQueueItem = queue.pop_front()
		play(next.key, false, next.is_loop)
	else:
		currently_playing = ""
		active_player.stop()
		
class AudioQueueItem:
	var is_loop: bool = false
	var key: String = ""
	
	func _init(p_key: String, p_is_loop: bool = false) -> void:
		key = p_key
		is_loop = p_is_loop
