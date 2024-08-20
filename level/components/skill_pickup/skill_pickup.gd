extends Node2D

@export var skill : Player.Skill
@export var textures : Array[Texture2D]
@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	player_interactor.player_entered.connect(_on_player_entered)
	sprite_2d.texture = textures[skill]

func _on_player_entered(player: Player) -> void:
	player.unlock_skill(skill)
	queue_free()
