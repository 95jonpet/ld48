extends Node2D

export(Array, Resource) var items = []

func is_completed() -> bool:
	return $Tiles.get_child_count() == 0
