extends Resource
class_name WorldLevels

@export var levels: Dictionary
@export var level_music: Dictionary

func get_level(level_name: String) -> PackedScene:
	assert(levels.has(level_name), "level %s not in levels dictionary" % level_name)
	return levels[level_name]
	
func get_music(level_name: String) -> AudioStream:
	assert(level_music.has(level_name), "music %s not in musicdictionary" % level_name)
	return level_music[level_name]
