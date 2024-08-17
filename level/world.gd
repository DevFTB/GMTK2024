extends Node2D
 
# TODO: note, this way we can stil potentailly make a minimap by putting all levels in the same scene after

@export var levels: Dictionary
# don't make this 0 or stuff will break lmao - the getenger
@export var level_transition_time = 1.0
@export var level_transition_screen: Control

@onready var level: Node2D = $Level
@onready var spawn_point: Node2D = $SpawnPoint
@onready var player: Player = $Player


func _ready() -> void:
	player.global_position = spawn_point.global_position
	player.killed.connect(_on_player_kill)
	connect_level_transitions(level)

func _on_player_kill() -> void:
	player.global_position = spawn_point.global_position
	
func load_level(new_level: PackedScene, spawn_point_name: String) -> void:
	level.queue_free()
	level = new_level.instantiate()
	self.add_child(level)
	spawn_point.global_position = level.get_node("Spawns").get_node(spawn_point_name).global_position
	player.global_position = spawn_point.global_position
	
	print(level.get_camera_bounds())
	
	pause()
	level_transition_screen.visible = true
	await get_tree().create_timer(level_transition_time).timeout
	level_transition_screen.visible = false
	resume()
	
	connect_level_transitions(level)
	
func _on_level_transition(level_name: String, spawn_point_name: String):
	assert(levels.has(level_name), "level %s not in levels dictionary" % level_name)
	load_level(levels[level_name], spawn_point_name)

func connect_level_transitions(level):
	for c in level.get_node("LevelTransitions").get_children():
		c.change_level.connect(_on_level_transition)

# TODO: do i need to stop more when pausing and resuming?
func pause():
	player.set_process(false)
	player.set_physics_process(false)
	
func resume():
	player.set_process(true)
	player.set_physics_process(true)
	
