extends Node2D
 
signal level_loaded
# TODO: note, this way we can stil potentailly make a minimap by putting all levels in the same scene after

@export var levels: WorldLevels
## don't make this 0 or stuff will break lmao - the getenger
#@export var level_transition_time = 1.0
@export var level_transition_screen: Control

@export var start_level_name := "level0"
@export var start_spawn_point := "Left1"

var _reloading := false

@onready var level: Level = get_node_or_null("Level")
@onready var spawn_point: Node2D = $SpawnPoint
@onready var spawn_point_name := start_spawn_point
@onready var player: Player = $Player
@onready var story_text_label: RichTextLabel = %StoryTextLabel

@onready var music_player : MusicPlayer = $MusicPlayer

func _ready() -> void:
	player.global_position = spawn_point.global_position
	player.killed.connect(_on_player_kill)
	
	load_level(levels.get_level(start_level_name), start_spawn_point)
	var level_music = levels.get_music(start_level_name)
	if level_music:
		queue_music(level_music)

func _on_player_kill() -> void:
	reload_level()

func reload_level() -> void:
	if not _reloading:
		await load_level(levels.get_level(level.level_name), spawn_point_name)
		player.reset()


func load_level(new_level: PackedScene, new_spawn_point_name: String) -> void:
	_reloading = true
	level_transition_screen.fade_out()
	await level_transition_screen.fade_out_completed
	
	if level:
		level.queue_free()
		await level.tree_exited
		
	# fix? stoopid weird bug where u spawn at global position of prev level spawn point
	# TODO: go to level and renable the timer in level.gd if double level transition bug keeps occurring
	await get_tree().physics_frame

	level = new_level.instantiate()
	add_child(level)

	spawn_point.global_position = level.get_spawn_point(new_spawn_point_name)
	spawn_point_name = new_spawn_point_name
	
	player.global_position = spawn_point.global_position
	player.velocity = Vector2.ZERO
	player._frame_velocity = Vector2.ZERO
	
	for cp in level.check_points:
		cp.checkpoint_reached.connect(_on_checkpoint_reached.bind(cp))

	level_transition_screen.fade_in()
	connect_level_transitions(level)
	
	var camera_bounds = level.get_camera_bounds()

	player.set_camera_limits(
		camera_bounds["left"], camera_bounds["top"],
		camera_bounds["right"], camera_bounds["bottom"]
	)
	
	level.start()
	_reloading = false

func display_story_text(text: String) -> void:
	player.paused = true
	#music_player.pause()

	story_text_label.display(text)
	await story_text_label.display_completed
	
	player.paused = false
	#music_player.resume()
	
func _on_checkpoint_reached(location: Vector2, checkpoint: Checkpoint) -> void:
	spawn_point.global_position = location
	spawn_point_name = checkpoint.name
	
func _on_level_transition(level_name: String, spawn_point_name: String):
	load_level(levels.get_level(level_name), spawn_point_name)
	var level_music = levels.get_music(start_level_name)
	if level_music:
		queue_music(level_music)

# TODO: seems to be an error that changle_level is already connected. not causing any grif at the moment, but could be connected to the prior issue
func connect_level_transitions(new_level: Level):
	if new_level.level_transitions:
		for c in new_level.level_transitions:
			if not c.change_level.is_connected(_on_level_transition):
				c.change_level.connect(_on_level_transition)

# TODO: do i need to stop more when pausing and resuming?
func pause():
	player.set_process(false)
	player.set_physics_process(false)
	
func resume():
	player.set_process(true)
	player.set_physics_process(true)
	
func queue_music(track):
	music_player.clear_queue()
	music_player.queue_music(track)
	
	
