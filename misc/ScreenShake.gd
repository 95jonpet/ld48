extends Node

var amplitude = 0
var priority = 0

onready var camera = get_parent()

func start(duration: float = 0.2, frequency: float = 15, shake_amplitude: float = 8, shake_priority: int = 0):
	if shake_priority >= priority:
		amplitude = shake_amplitude
		priority = shake_priority
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		
		$Duration.start()
		$Frequency.start()

func _new_shake():
	var rand = Vector2.ZERO
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$ShakeTween.start()

func _reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$ShakeTween.start()
	priority = 0

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
