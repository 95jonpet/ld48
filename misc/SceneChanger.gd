extends CanvasLayer

signal scene_changed()
signal scene_loaded()

onready var animation_player = $AnimationPlayer
onready var level_name_label = $Control/VBoxContainer/LevelNameLabel
onready var level_hint_label = $Control/VBoxContainer/LevelHintLabel
onready var black = $Black

func _ready():
	animation_player.stop()

func change_scene(path: String, old_level: Node, level_name: String = ""):
	animation_player.stop()
	
	# Instantiate the new level.
	var new_level = load(path).instance()
	var parent = old_level.get_parent()
	var pos_in_parent = old_level.get_position_in_parent()
	
	# Fade out the screen.
	level_name_label.text = level_name
	level_hint_label.text = new_level.level_hint
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	animation_player.stop()
	
	# Dispose of the old level.
	parent.call_deferred("remove_child", old_level)
	yield(old_level, "tree_exited")
	old_level.queue_free()
	
	# Replace the old level with an instance of the the new level.
	new_level.hide()
	parent.call_deferred("add_child", new_level)
	yield(new_level, "tree_entered")
	parent.move_child(new_level, pos_in_parent)
	new_level.show()
	
	# Notify observers that the new scene has been loaded and added to the scene tree.
	emit_signal("scene_loaded", new_level)
	
	# Fade in the screen.
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	animation_player.stop()
	emit_signal("scene_changed")	
