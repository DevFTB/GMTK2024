extends Node

@onready var player: Player = $World/Player
@onready var minimap: Control = $CanvasLayer/GUI/Minimap

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug3"):
		player.kill()
	if event.is_action_pressed("minimap"):
		if not minimap.visible:
			minimap.open()
			player.paused = true
		else:
			minimap.hide()
			player.paused = false
