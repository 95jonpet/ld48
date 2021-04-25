extends StaticBody2D

const MAX_HEALTH = 2
export(int) var health: = MAX_HEALTH

onready var health_textures = [
	preload("res://tiles/obsidian_tile_damaged.png"),
	preload("res://tiles/obsidian_tile.png")
]

func _ready():
	update_texture()

func update_texture():
	$Sprite.texture = health_textures[round(clamp(health - 1, 0, health_textures.size() - 1))]

func destroy():
	health -= 1
	update_texture()
	$CollisionShape2D.set_deferred("disabled", true)
	
	if health <= 0:
		hide()
	
	$DestroyedSound.play()
	yield($DestroyedSound, "finished")
	
	if health <= 0:
		queue_free()
	else:
		$CollisionShape2D.set_deferred("disabled", false)
