extends StaticBody2D
class_name BreakableWall

signal broken

@export var texture_top: Texture2D
@export var texture_fill: Texture2D
@export var texture_bottom: Texture2D

var is_broken := false

var _timer := 0.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var extents := collision_shape_2d.shape.get_rect()
@onready var sprites: Node2D = $Sprites

func _ready() -> void:
	_generate_sprite()
	

func _generate_sprite() -> void:
	var tiles := extents.size.y / 32
	
	for i in range(tiles):
		var sprite := Sprite2D.new()
		sprite.position = Vector2(0, i * 32)
		sprite.centered = false
		
		if i == 0:
			sprite.texture = texture_top
		elif i == tiles - 1:
			sprite.texture = texture_bottom
		else:
			sprite.texture = texture_fill
		
		sprites.add_child(sprite)

func _break() -> void:
	is_broken = true
	
	collision_shape_2d.set_deferred("disabled", true)
	# TODO: play animation for broken platform
	
	broken.emit()
	queue_free()
