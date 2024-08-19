extends Powerable

@export var texture_top: Texture2D
@export var texture_fill: Texture2D
@export var texture_bottom: Texture2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var extents := collision_shape_2d.shape.get_rect()
@onready var sprites: Node2D = $Sprites

func _ready() -> void:
	super()
	power_changed.connect(_on_power_changed)
	
func _on_power_changed(new_value: bool) -> void:
	collision_shape_2d.set_deferred("disabled", new_value)
	_generate_sprite()
	
func _generate_sprite() -> void:
	var tiles := extents.size.y / 32
	
	for child in sprites.get_children():
		child.queue_free()
	
	if powered:
		for i in range(tiles):
			var sprite := Sprite2D.new()
			sprite.position = Vector2(0, 32 * i)
			sprite.centered = false
			
			if i == 0:
				sprite.texture = texture_top
			elif i == tiles - 1:
				sprite.texture = texture_bottom
			else:
				sprite.texture = texture_fill
			
			sprites.add_child(sprite)
