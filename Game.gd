extends Node2D

const FIRST_LEVEL_NUMBER = 1 # The level to go to after showing an initial starting screen.

onready var ui_animation = $Camera/Interface/AnimationPlayer

var active_item_index: int = 0
var can_place_item: bool = true
var level_number: int = 0
var level_locks = []

func _ready():
	assert(SceneChanger.connect("scene_loaded", self, "_on_level_changed") == OK)
	change_level(0)
	
	# Trigger scene change when entering the first level.
	# Wait a few seconds first in order to show the starting screen.
	yield(SceneChanger, "scene_loaded")
	yield(get_tree().create_timer(3), "timeout")
	SceneChanger.changing_scene = false # Allow scene change to be forced.
	change_level(FIRST_LEVEL_NUMBER)

func register_level_lock(lock):
	if level_locks.has(lock):
		# Prevent duplicates.
		return
	
	level_locks.push_back(lock)

func unregister_level_lock(lock):
	level_locks.erase(lock)
	trigger_level_change_if_needed()

func change_level(level: int):
	var level_file_path = "res://levels/Level" + str(level) + ".tscn"
	var level_file_exists = File.new().file_exists(level_file_path)
	
	if level_file_exists:
		level_number = level
		SceneChanger.change_scene(level_file_path, $Level, "Level " + str(level))
	else:
		# All levels have been completed.
		# Restart the game from the first level.
		assert(get_tree().reload_current_scene() == OK)

func trigger_level_change_if_needed():
	# The level cannot be locked by any nodes.
	if not level_locks.empty():
		return
	
	if active_item_index == $Level.items.size():
		# All items have been used. Check for win/loss.
		if $Level.is_completed():
			$LevelWin.play()
			change_level(level_number + 1)
		else:
			$LevelLose.play()
			change_level(level_number)

func _input(event):
	if event.is_action_pressed("level_skip") and level_number > 0:
		change_level(level_number + 1)

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

func _on_level_changed(level: Node = null):
	ui_animation.stop()
	active_item_index = 0
	$Camera/Interface.set_inventory_items(level.items if level else $Level.items)
	$Camera/Interface.set_inventory_active_item(active_item_index)
	
	yield(get_tree().create_timer(3), "timeout")
	ui_animation.play("ui-load")
