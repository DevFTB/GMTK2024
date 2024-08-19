extends StaticBody2D

signal broken

@export var durability : float = 5

@export var texture_left: Texture2D
@export var texture_fill: Texture2D
@export var texture_right: Texture2D

var is_broken := false

var _timer := 0.0

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var _durability : float = durability

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var extents := collision_shape_2d.shape.get_rect()
@onready var sprites: Node2D = $Sprites



func _ready() -> void:
	_generate_sprite()
	player_interactor.player_exited.connect(_on_player_exited.unbind(1))
	broken.connect(print.bind("i am mcbroken"))

func _generate_sprite() -> void:
	var tiles := extents.size.x / 32
	
	for i in range(tiles):
		var sprite := Sprite2D.new()
		sprite.position = Vector2(i * 32, 0)
		sprite.centered = false
		
		if i == 0:
			sprite.texture = texture_left
		elif i == tiles - 1:
			sprite.texture = texture_right
		else:
			sprite.texture = texture_fill
		
		sprites.add_child(sprite)

func _physics_process(delta: float) -> void:
	if player_interactor.has_player:
		var player := player_interactor.interacting_player
		
		_durability -= player.stats.mass * delta
		var ratio = 1.0 - _durability / durability
		_timer += delta
		sprites.position = Vector2(cos(10 * ratio * _timer) * sin(_timer), 0)
		
		if _durability < 0 and not is_broken:
			_break()

func _break() -> void:
	is_broken = true
	
	collision_shape_2d.set_deferred("disabled", true)
	
	# TODO: play animation for broken platform
	
	broken.emit()
	queue_free()

func _on_player_exited() -> void:
	_durability = durability
