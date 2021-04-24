extends Control

func set_inventory_active_item(item_index):
	$Inventory.set_active_item(item_index)

func set_inventory_items(items):
	$Inventory.items = items
	$Inventory.reset_controls()
