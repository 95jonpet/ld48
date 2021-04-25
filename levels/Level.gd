extends Node2D

export(String) var level_name = ""
export(String, MULTILINE) var level_hint = ""
export(Array, Resource) var items = []

func is_completed() -> bool:
	return $Tiles.get_child_count() == 0
