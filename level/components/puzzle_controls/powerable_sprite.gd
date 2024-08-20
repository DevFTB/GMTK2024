extends Sprite2D

@export var puzzle_control: PuzzleControl
@export var powered_texture: Texture2D
@export var unpowered_texture: Texture2D

func _ready() -> void:
	puzzle_control.power_changed.connect(_on_power_changed)
	_on_power_changed(puzzle_control.is_powered())
	
func _on_power_changed(new_value: bool) -> void:
	texture = powered_texture if new_value else unpowered_texture
