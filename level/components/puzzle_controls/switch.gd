extends PuzzleControl

@onready var player_interactor: PlayerInteractor = $PlayerInteractor

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_interactor.has_player:
			set_power(not _powering)
