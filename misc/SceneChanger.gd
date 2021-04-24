extends CanvasLayer

signal scene_changed()
signal scene_loaded()

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func change_scene(path: String, old_level: Node, delay = 0.5):
	# Fade out the screen.
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	
	# Instantiate the new level.
	var new_level = load(path).instance()
	var parent = old_level.get_parent()
	var pos_in_parent = old_level.get_position_in_parent()
	emit_signal("scene_loaded", new_level)
	
	# Dispose of the old level.
	parent.call_deferred("remove_child", old_level)
	yield(old_level, "tree_exited")
	old_level.queue_free()
	
	# Replace the old level with an instance of the the new level.
	parent.call_deferred("add_child", new_level)
	yield(new_level, "tree_entered")
	parent.move_child(new_level, pos_in_parent)
	
	# Fade in the screen.
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
