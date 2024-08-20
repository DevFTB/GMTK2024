extends Sprite2D

@export var state_to_texture = {}
@export var initial_state: String

func _ready() -> void:
	set_state(initial_state)

func set_state(state: String) -> void:
	texture = state_to_texture.get(state)
