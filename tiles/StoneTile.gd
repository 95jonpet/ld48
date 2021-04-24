extends StaticBody2D

func destroy():
	$CollisionShape2D.disabled = true
	hide()
	
	$DestroyedSound.play()
	yield($DestroyedSound, "finished")
	queue_free()
