extends Node2D
 
# TODO: note, this way we can stil potentailly make a minimap by putting all levels in the same scene after

@export var levels: Dictionary
# don't make this 0 or stuff will break lmao - the getenger
@export var level_transition_time = 1.0
@export var level_transition_screen: Control

@onready var level: Level = $Level
@onready var spawn_point: Node2D = $SpawnPoint
@onready var player: Player = $Player

func _ready() -> void:
	player.global_position = spawn_point.global_position
	player.killed.connect(_on_player_kill)
	connect_level_transitions(level)
	level.start()
	
	var camera_bounds = level.get_camera_bounds()
	print(camera_bounds)
	player.set_camera_limits(
		camera_bounds["left"], camera_bounds["top"],
		camera_bounds["right"], camera_bounds["bottom"]
	)

func _on_player_kill() -> void:
	player.global_position = spawn_point.global_position
	
func load_level(new_level: PackedScene, spawn_point_name: String) -> void:
	level_transition_screen.fade_out()
	await level_transition_screen.fade_out_completed
	
	level.queue_free()
	level = new_level.instantiate()
	add_child(level)

	spawn_point.global_position = level.get_spawn_point(spawn_point_name)
	player.global_position = spawn_point.global_position

	level_transition_screen.fade_in()
	connect_level_transitions(level)
	
	level.start()

	var camera_bounds = level.get_camera_bounds()
	player.set_camera_limits(
		camera_bounds["left"], camera_bounds["top"],
		camera_bounds["right"], camera_bounds["bottom"]
	)
	
func _on_level_transition(level_name: String, spawn_point_name: String):
	assert(levels.has(level_name), "level %s not in levels dictionary" % level_name)
	load_level(levels[level_name], spawn_point_name)

func connect_level_transitions(level: Level):
	if level.level_transitions:
		for c in level.level_transitions:
			c.change_level.connect(_on_level_transition)

# TODO: do i need to stop more when pausing and resuming?
func pause():
	player.set_process(false)
	player.set_physics_process(false)
	
func resume():
	player.set_process(true)
	player.set_physics_process(true)
	
