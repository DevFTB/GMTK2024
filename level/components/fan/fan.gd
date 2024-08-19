extends Powerable

@onready var fan_area: PlayerInteractor = $Fan/FanArea
@export var force : Vector2

@onready var gpu_particles_2d: GPUParticles2D = $Fan/Sprite2D/ClippingRect/GPUParticles2D

var _added_force : bool = false

var _player : Player

var _dir_to_player:
	get:
		return -force.normalized()

var should_apply: bool:
	get:
		var should = powered and not _added_force and _player.active_environment_detector.is_active_colliding(_dir_to_player)
		return should
		
var should_remove: bool:
	get:
		return not powered or (_added_force and not _player.active_environment_detector.is_active_colliding(_dir_to_player))

func _ready() -> void:
	super()
	
	fan_area.player_entered.connect(_add_player)
	fan_area.player_exited.connect(_remove_player)
	power_changed.connect(_on_power_changed)
	_on_power_changed(powered)
	
func _physics_process(_delta: float) -> void:
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
	player.external_forces[self] = force / _player.stats.mass
	_added_force = true
	
func _remove_force(player: Player) -> void:
	player.external_forces.erase(self)
	_added_force = false

func _on_power_changed(new_value: bool) -> void:
	gpu_particles_2d.emitting = new_value
