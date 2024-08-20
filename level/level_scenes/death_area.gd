extends PlayerInteractor

func _ready() -> void:
	player_entered.connect(func(player): player.kill())
