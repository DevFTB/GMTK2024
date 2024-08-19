extends Powerable

@export var texture_top: Texture2D
@export var texture_fill: Texture2D
@export var texture_bottom: Texture2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var extents := collision_shape_2d.shape.get_rect()
@onready var sprites: Node2D = %Sprites

func _ready() -> void:
	super()
	_generate_sprite() 
	power_changed.connect(_on_power_changed)
	_on_power_changed(powered)
	
func _on_power_changed(new_value: bool) -> void:
	collision_shape_2d.set_deferred("disabled", not new_value)
	
	if new_value:
		_deploy()
	else:
		_retract()
	
func _generate_sprite() -> void:
	var tiles := extents.size.y / 32
	
	for child in sprites.get_children():
		child.queue_free()
	
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

func _retract() -> void:
	var tween = create_tween()
	tween.tween_property(sprites, "position", Vector2(0.0, -extents.size.y), 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

func _deploy() -> void:
	var tween = create_tween()
	tween.tween_property(sprites, "position", Vector2(0.0, 0.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
