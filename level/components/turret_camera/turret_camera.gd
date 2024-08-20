extends Powerable
class_name TurretCamera

@export var auto_polygon_2d : bool = true
@export var tracking_duration: float = 1.5

var _in_area := false
var _is_shooting = false

var _is_tracking_player: bool:
	get:
		return ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() is Player

var player_position: Vector2:
	get:
		return player_interactor.interacting_player.com - global_position

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var ray_shooter: VisualRayShooter = $RayShooter
@onready var collision_polygon_2d: CollisionPolygon2D = $PlayerInteractor/CollisionPolygon2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var turret_build: AudioStreamPlayer2D = $TurretBuild
@onready var turret_shoot: AudioStreamPlayer2D = $TurretShoot
@onready var polygon_2d: Polygon2D = $Polygon2D


func _ready() -> void:
	player_interactor.player_entered.connect(_on_player_entered.unbind(1))
	player_interactor.player_exited.connect(_on_player_exited.unbind(1))
	
	shoot_timer.wait_time = tracking_duration
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	
	if auto_polygon_2d:
		polygon_2d.polygon = collision_polygon_2d.polygon * collision_polygon_2d.transform.inverse() * player_interactor.transform.inverse()

func _on_player_entered() -> void:
	_in_area = true
func _on_player_exited() -> void:
	_in_area = false
	_stop_shooting()
	
func _physics_process(_delta: float) -> void:
	if _in_area:
		ray_cast_2d.target_position = player_position
		ray_cast_2d.force_raycast_update()
		if _is_shooting:
			queue_redraw()
			
			if not _is_tracking_player:
				_stop_shooting()
		else:
			if _is_tracking_player:
				_start_shooting()

func _on_shoot_timer_timeout() -> void:
	_fire()

func _fire() -> void:
	var player = player_interactor.interacting_player
	var target_position = player_position

	ray_cast_2d.target_position = target_position
	ray_cast_2d.force_raycast_update()
	turret_shoot.play()
	ray_shooter.shoot_ray(Vector2(), target_position)
	if _is_tracking_player:
		get_tree().create_timer(ray_shooter.default_duration).timeout.connect(player.kill)
		_stop_shooting()

func _start_shooting() -> void:
	shoot_timer.start()
	queue_redraw()
	turret_build.play()
	polygon_2d.hide()
	
	_is_shooting = true


func _stop_shooting() -> void:
	_is_shooting = false
	shoot_timer.stop()
	queue_redraw()
	turret_build.stop()
	polygon_2d.show()
	
	
func _draw() -> void:
	var player = player_interactor.interacting_player
	if player:
		var target_position = player.com - ray_cast_2d.global_position 
		if _is_shooting:
			var ratio = 1 - shoot_timer.time_left / shoot_timer.wait_time
			draw_line(sprite_2d.position, target_position, Color(1.0, 0.6 - ratio + 0.4, 0.6 - ratio + 0.4), 1.5 * ratio + 1.0)
