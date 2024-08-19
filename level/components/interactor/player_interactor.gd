extends Area2D
class_name PlayerInteractor

@export_flags("Small", "Normal", "Big") var size_flags : int = 7

signal player_entered(player: Player)
signal player_exited(player: Player)

var interacting_player : Player

var _disabled := false

var has_player: bool:
	get:
		return interacting_player != null
		
var right_player_size: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player and not _disabled:
		right_player_size = size_flags & 2 ** body.size_mode
		if right_player_size:
			interacting_player = body
			player_entered.emit(body)
	
func _on_body_exited(body: Node2D) -> void:		
	if body is Player and not _disabled:
		interacting_player = null
		
		if right_player_size:
			player_exited.emit(body)


func set_disabled(value: bool) -> void:
	_disabled = value
