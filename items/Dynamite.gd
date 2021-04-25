extends KinematicBody2D

const Explosion = preload("res://effects/Explosion.tscn")
const EXPLOSION_OFFSET = 24

onready var game = $"../.."

func _ready():
	game.register_level_lock(self)

func _on_Timer_timeout():
	$ExplosionSound.play()
	hide()
	
	var centerExplosion = add_explosion(position)
	assert(add_explosion(position - Vector2(EXPLOSION_OFFSET, 0)) != null)
	assert(add_explosion(position + Vector2(EXPLOSION_OFFSET, 0)) != null)
	assert(add_explosion(position - Vector2(0, EXPLOSION_OFFSET)) != null)
	assert(add_explosion(position + Vector2(0, EXPLOSION_OFFSET)) != null)
	
	yield(centerExplosion, "cleared")
	game.unregister_level_lock(self)
	queue_free()

func add_explosion(position: Vector2) -> Node2D:
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	return explosion
