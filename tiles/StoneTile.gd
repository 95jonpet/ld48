extends StaticBody2D

func destroy():
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	
	$DestroyedSound.play()
	yield($DestroyedSound, "finished")
	queue_free()
