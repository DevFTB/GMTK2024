extends PuzzleControl

@onready var player_interactor: PlayerInteractor = $PlayerInteractor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	player_interactor.player_entered.connect(set_power.bind(true).unbind(1))
	player_interactor.player_exited.connect(set_power.bind(false).unbind(1))
