extends Node2D

var active_item_index: int = 0
var can_place_item: bool = true
var level_number: int = 1

func _ready():
	assert(SceneChanger.connect("scene_loaded", self, "_on_level_changed") == OK)
	_on_level_changed()
	change_level(level_number) # Trigger scene change when entering the first level.

func change_level(level: int):
	var level_file_path = "res://levels/Level" + str(level) + ".tscn"
	var level_file_exists = File.new().file_exists(level_file_path)
	
	if level_file_exists:
		SceneChanger.change_scene(level_file_path, $Level, "Level " + str(level))
	else:
		# TODO: Handle game end with all levels completed.
		assert(get_tree().reload_current_scene() == OK)

func _on_grid_placeholder_clicked(placeholder):
	if not can_place_item:
		return
	
	if active_item_index < $Level.items.size():
		var active_item = $Level.items[active_item_index]
		var instance = active_item.scene.instance()
		instance.position = placeholder.position
		$Level.add_child(instance)
		$GridItemPlaced.play()
		
		can_place_item = false
		$TurnTimer.call_deferred("start")
		yield($TurnTimer, "timeout")
		can_place_item = true
		
		active_item_index += 1
		$Camera/Interface.set_inventory_active_item(active_item_index)
		
		$TurnTimer.call_deferred("start")
		yield($TurnTimer, "timeout")
		
		if active_item_index == $Level.items.size():
			if $Level.is_completed():
				level_number += 1
			
			change_level(level_number)

func _on_level_changed(level: Node = null):
	active_item_index = 0
	$Camera/Interface.set_inventory_items(level.items if level else $Level.items)
	$Camera/Interface.set_inventory_active_item(active_item_index)
