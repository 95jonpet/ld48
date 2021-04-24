extends CenterContainer

const InventorySlot = preload("res://ui/InventorySlot.tscn")
export(Array, Resource) var items = []

var active_index = 0

func _ready():
	reset_controls()

func set_active_item(item_index):
	active_index = item_index
	reset_controls()

func reset_controls():
	for child in $Container.get_children():
		child.queue_free()
	
	for item_index in items.size():
		var slot = InventorySlot.instance()
		slot.display_item(items[item_index])
		slot.set_active(item_index == active_index)
		slot.set_used(item_index < active_index)
		$Container.add_child(slot)
