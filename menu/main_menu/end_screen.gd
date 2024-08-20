extends Control

@export var main_menu_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("show")

func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
