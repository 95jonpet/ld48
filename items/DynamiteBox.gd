extends KinematicBody2D

const Explosion = preload("res://effects/Explosion.tscn")
const EXPLOSION_OFFSET = 24

onready var game = $"../.."

func destroy():
	game.register_level_lock(self)
	$AnimationPlayer.play("Flash")
	$FuseSound.play()
	$Timer.call_deferred("start")
	yield($Timer, "timeout")

func _on_Timer_timeout():
	$FuseSound.stop()
	$ExplosionSound.play()
	game.request_screen_shake(0.6, 15, 16)
	hide()
	
	# Inner plus.
	var centerExplosion = add_explosion(position)
	add_explosion(position - Vector2(EXPLOSION_OFFSET, 0))
	add_explosion(position + Vector2(EXPLOSION_OFFSET, 0))
	add_explosion(position - Vector2(0, EXPLOSION_OFFSET))
	add_explosion(position + Vector2(0, EXPLOSION_OFFSET))
	
	# Outer plus.
	add_explosion(position - Vector2(EXPLOSION_OFFSET, 0) * 2)
	add_explosion(position + Vector2(EXPLOSION_OFFSET, 0) * 2)
	add_explosion(position - Vector2(0, EXPLOSION_OFFSET) * 2)
	add_explosion(position + Vector2(0, EXPLOSION_OFFSET) * 2)
	
	# Corners.
	add_explosion(position + Vector2(-EXPLOSION_OFFSET, -EXPLOSION_OFFSET))
	add_explosion(position + Vector2(EXPLOSION_OFFSET, -EXPLOSION_OFFSET))
	add_explosion(position + Vector2(-EXPLOSION_OFFSET, EXPLOSION_OFFSET))
	add_explosion(position + Vector2(EXPLOSION_OFFSET, EXPLOSION_OFFSET))
	
	yield(centerExplosion, "cleared")
	game.unregister_level_lock(self)
	queue_free()

func add_explosion(position: Vector2):
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	return explosion
