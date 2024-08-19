extends PuzzleControl

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var pushable_interactor: Area2D = $PushableInteractor

var has_bodies: bool:
	get:
		return player_interactor.interacting_player or pushable_interactor.get_overlapping_bodies().size() > 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	player_interactor.player_entered.connect(_on_body_entered)
	player_interactor.player_exited.connect(_on_body_exited)
	pushable_interactor.body_entered.connect(_on_body_entered)
	pushable_interactor.body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	print(body)
	
	if has_bodies:
		set_power(true)
		$FXPlayer.play()
	

func _on_body_exited(body: Node2D) -> void:
	if not has_bodies:
		set_power(false)
