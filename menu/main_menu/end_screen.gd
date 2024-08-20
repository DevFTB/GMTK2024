extends Control

@export var main_menu_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const MAIN_MENU = preload("res://menu/main_menu/main_menu.tscn")
func _ready() -> void:
	animation_player.play("show")

func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
