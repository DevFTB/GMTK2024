extends RichTextLabel

signal display_completed

@export var character_speed : float = 10
var _tween : Tween

func display(new_text: String = "") -> void:
	show()
	if new_text != "":
		text = new_text
		
	visible_characters = 0

	_tween = create_tween()
	_tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(Color.WHITE, 0.0))
	_tween.tween_property(self, "visible_characters", text.length(), text.length() / character_speed).from(0)
	_tween.tween_callback(_on_display_completed).set_delay(1.0)

func _on_display_completed() -> void:
	display_completed.emit()
	hide()
