extends Node2D

var active_item_index = 0

func _ready():
	_on_level_changed()

func _on_grid_placeholder_clicked(placeholder):
	if active_item_index < $Level.items.size():
		var active_item = $Level.items[active_item_index]
		var instance = active_item.scene.instance()
		instance.position = placeholder.position
		$Level.add_child(instance)
		$GridItemPlaced.play()
		
		active_item_index += 1
		$Camera/Interface.set_inventory_active_item(active_item_index)

func _on_level_changed():
	active_item_index = 0
	$Camera/Interface.set_inventory_items($Level.items)
	$Camera/Interface.set_inventory_active_item(active_item_index)
