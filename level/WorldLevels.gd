extends Resource
class_name WorldLevels

@export var levels: Dictionary

func get_level(level_name: String) -> PackedScene:
	assert(levels.has(level_name), "level %s not in levels dictionary" % level_name)
	return levels[level_name]
