extends StaticBody2D

@onready var fan_area: PlayerInteractor = $FanArea

@export var force : Vector2

var _added_force : bool = false

var _player : Player

var _dir_to_player:
	get:
		return -force.normalized()

func _ready() -> void:
	fan_area.player_entered.connect(_apply_force)
	fan_area.player_exited.connect(_remove_force)
	
func _physics_process(delta: float) -> void:
	
	if _player:
		if not _added_force and _player.active_environment_detector.is_active_colliding(_dir_to_player):
			_apply_force(_player)
		
		if _added_force and not _player.active_environment_detector.is_active_colliding(_dir_to_player):
			_remove_force(_player)
		
func _apply_force(player: Player) -> void:
	_player = player
	if player.active_environment_detector.is_active_colliding(_dir_to_player):
		player.external_forces.append(force / _player.stats.mass)
		_added_force = true
	
func _remove_force(player: Player) -> void:
	if _added_force:
		player.external_forces.erase(force / _player.stats.mass)
		_added_force = false
		_player = null
