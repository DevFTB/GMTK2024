extends Resource
class_name WorldLevels

@export var levels: Dictionary
@export var level_music: Dictionary

func get_level(level_name: String) -> PackedScene:
	assert(levels.has(level_name), "level %s not in lddddevels dictionary" % level_name)
	return levels[level_name]
	
func get_music(level_name: String) -> AudioStream:
	if not level_music.has(level_name):
		push_warning("level %s has no music in level_music dictionary" % level_name)
		return null
	return level_music[level_name]
