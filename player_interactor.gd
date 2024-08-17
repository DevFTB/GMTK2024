extends Area2D
class_name PlayerInteractor

signal player_entered(player: Player)
signal player_exited(player: Player)

var interacting_player : Player

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		interacting_player = body
		player_entered.emit(body)
	
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		interacting_player = null
		player_exited.emit(body)
