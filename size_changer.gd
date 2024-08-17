extends Node2D

@export_flags("SMALL", "NORMAL", "BIG") var size_flags = 0

const order = [Player.SizeMode.SMALL, Player.SizeMode.NORMAL, Player.SizeMode.BIG]

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var control_gui: HBoxContainer = $ControlGUI

func _ready() -> void:
	control_gui.hide()
	player_interactor.player_entered.connect(control_gui.show.unbind(1))
	player_interactor.player_exited.connect(control_gui.hide.unbind(1))

func _input(event: InputEvent) -> void:
	var player := player_interactor.interacting_player
	
	if player:
		if event.is_action_pressed("change_size_down"):
			var index = order.find(player.size_mode)
			var new_index = index - 1
			if _can_change_down(player, new_index):

				player.switch_size(order[new_index])
			
		if event.is_action_pressed("change_size_up"):
			var index = order.find(player.size_mode)
			var new_index = index + 1
			if _can_change_up(player, new_index):
				player.switch_size(order[new_index])

func _can_change_down(player: Player, new_index: int) -> bool:
	return new_index >= 0 and size_flags & 1 << new_index
	
func _can_change_up(player: Player, new_index: int) -> bool:
	return new_index < order.size() and size_flags & 1 << new_index
