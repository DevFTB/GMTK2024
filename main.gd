extends Node

@onready var player: Player = $World/Player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug3"):
		player.kill()
