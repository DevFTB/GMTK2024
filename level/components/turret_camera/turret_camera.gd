extends Powerable
class_name TurretCamera

var _is_shooting = false

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var ray_shooter: VisualRayShooter = $RayShooter

@onready var turret_build: AudioStreamPlayer2D = $TurretBuild
@onready var turret_shoot: AudioStreamPlayer2D = $TurretShoot


func _ready() -> void:
	player_interactor.player_entered.connect(_start_shooting.unbind(1))
	player_interactor.player_exited.connect(_stop_shooting.unbind(1))
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _process(delta: float) -> void:
	if _is_shooting:
		queue_redraw()

func _on_shoot_timer_timeout() -> void:
	_fire()

func _fire() -> void:
	var player = player_interactor.interacting_player
	var target_position = player.com.global_position - global_position

	ray_cast_2d.target_position = target_position
	ray_cast_2d.force_raycast_update()
	turret_shoot.play()
	ray_shooter.shoot_ray(Vector2(), target_position)
	print(ray_cast_2d.is_colliding())
	if ray_cast_2d.is_colliding():
		get_tree().create_timer(ray_shooter.default_duration).timeout.connect(player.kill)
		_stop_shooting()

func _start_shooting() -> void:
	_is_shooting = true
	shoot_timer.start()
	queue_redraw()
	turret_build.play()

func _stop_shooting() -> void:
	_is_shooting = false
	shoot_timer.stop()
	queue_redraw()
	turret_build.stop()
	
func _draw() -> void:
	var player = player_interactor.interacting_player
	if player:
		var target_position = player.com.global_position - ray_cast_2d.global_position 
		if _is_shooting:
			var ratio = 1 - shoot_timer.time_left / shoot_timer.wait_time
			draw_line(Vector2(), target_position, Color(1.0, 0.6 - ratio + 0.4, 0.6 - ratio + 0.4), 1.5 * ratio + 1.0)
