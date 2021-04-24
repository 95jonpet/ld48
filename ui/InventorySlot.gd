extends CenterContainer

const ACTIVE_TEXTURE = preload("res://ui/item_active.png")
const INACTIVE_TEXTURE = preload("res://ui/item_inactive.png")

func set_active(active: bool):
	$BackgroundTextureRect.texture = ACTIVE_TEXTURE if active else INACTIVE_TEXTURE

func set_used(used: bool):
	$ItemTextureRect.modulate = Color(0.5, 0.5, 0.5) if used else Color.white

func display_item(item):
	if item is Item:
		$ItemTextureRect.texture = item.texture
	else:
		# TODO: Display empty slot.
		pass
