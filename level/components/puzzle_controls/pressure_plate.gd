extends PuzzleControl

@onready var player_interactor: Area2D = $PlayerInteractor

var _body_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	player_interactor.body_entered.connect(_on_body_entered.unbind(1))
	player_interactor.body_exited.connect(_on_body_exited.unbind(1))

func _on_body_entered() -> void:
	set_power(true)
	$FXPlayer.play()
	_body_count += 1
	

func _on_body_exited() -> void:
	_body_count -= 1
	
	if _body_count == 0:
		set_power(false)
