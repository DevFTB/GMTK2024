extends PuzzleControl

@onready var player_interactor: Area2D = $PlayerInteractor

var _body_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	player_interactor.body_entered.connect(_on_body_entered)
	player_interactor.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	set_power(true)
	_body_count += 1

func _on_body_exited(body: Node2D) -> void:
	_body_count -= 1
	
	if _body_count == 0:
		set_power(false)
