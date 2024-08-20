extends Node2D

@export var story_text = "the quick brown fox jumped over the lazy dog."

@onready var player_interactor: PlayerInteractor = $PlayerInteractor
@onready var tutorial_in_world: Node2D = $TutorialInWorld
@onready var world = get_tree().get_first_node_in_group('world')

var _interacting = false

func _ready() -> void:
	player_interactor.player_entered.connect(tutorial_in_world.fade_in.unbind(1))
	player_interactor.player_exited.connect(tutorial_in_world.fade_out.unbind(1))
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not _interacting and player_interactor.interacting_player:
		_interacting = true
		world.story_text_label.display_completed.connect(_on_cutscene_end, CONNECT_ONE_SHOT)
		start_cutscene()
		
func start_cutscene() -> void:
	world.display_story_text(story_text)
	tutorial_in_world.hide()

func _on_cutscene_end() -> void:
	_interacting = false
	tutorial_in_world.show()
