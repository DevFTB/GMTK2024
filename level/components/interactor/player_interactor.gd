extends Area2D
class_name PlayerInteractor

signal player_entered(player: Player)
signal player_exited(player: Player)

var interacting_player : Player

var _disabled := false

var has_player: bool:
	get:
		return interacting_player != null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player and not _disabled:
		interacting_player = body
		player_entered.emit(body)
	
func _on_body_exited(body: Node2D) -> void:
	if body is Player and not _disabled:
		interacting_player = null
		player_exited.emit(body)

func set_disabled(value: bool) -> void:
	_disabled = value
