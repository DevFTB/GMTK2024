extends Powerable

@onready var fan_area: PlayerInteractor = $Fan/FanArea
@export var force : Vector2

var _added_force : bool = false

var _player : Player

var _dir_to_player:
	get:
		return -force.normalized()

var should_apply: bool:
	get:
		return powered and not _added_force and _player.active_environment_detector.is_active_colliding(_dir_to_player)

var should_remove: bool:
	get:
		return not powered or (_added_force and not _player.active_environment_detector.is_active_colliding(_dir_to_player))

func _ready() -> void:
	fan_area.player_entered.connect(_add_player)
	fan_area.player_exited.connect(_remove_player)
	power_changed.connect(prints.bind("hehe"))
	
func _physics_process(delta: float) -> void:
	if _player:
		if should_apply:
			_apply_force(_player)
		
		if should_remove:
			_remove_force(_player)

func _add_player(player: Player) -> void:
	_player = player
	if should_apply:
		_apply_force(player)

func _remove_player(player: Player) -> void:
	_remove_force(player)
	_player = null

func _apply_force(player: Player) -> void:
	player.external_forces.append(force / _player.stats.mass)
	_added_force = true
	
func _remove_force(player: Player) -> void:
	player.external_forces.erase(force / _player.stats.mass)
	_added_force = false
