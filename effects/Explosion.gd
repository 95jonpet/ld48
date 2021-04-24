extends Node2D

signal cleared()

func _on_Timer_timeout():
	emit_signal("cleared")
	queue_free()

func _on_Explosion_body_entered(body):
	if body.is_in_group("destructible"):
		if body.has_method("destroy"):
			body.destroy()
		else:
			body.queue_free()
