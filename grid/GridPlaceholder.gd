extends Area2D

signal clicked()

const ACTIVE_TEXTURE = preload("res://grid/grid_placeholder_active.png")
const INACTIVE_TEXTURE = preload("res://grid/grid_placeholder.png")

var active: bool = false
onready var game_node = $"../../.."

func _ready():
	assert(connect("clicked", game_node, "_on_grid_placeholder_clicked", [self]) == OK)
	update_texture()

func update_texture():
	$Sprite.texture = ACTIVE_TEXTURE if active and get_overlapping_bodies().empty() else INACTIVE_TEXTURE

func _input(event):
	if not active:
		return
	
	if event.is_action_pressed("grid_click") && get_overlapping_bodies().empty():
		emit_signal("clicked")

func _on_GridPlaceholder_mouse_entered():
	active = true
	update_texture()

func _on_GridPlaceholder_mouse_exited():
	active = false
	update_texture()

func _on_GridPlaceholder_body_exited(_body):
	update_texture()

func _on_GridPlaceholder_body_shape_exited(_body_id, _body, _body_shape, _local_shape):
	update_texture()

func _on_GridPlaceholder_area_exited(_area):
	update_texture()

func _on_GridPlaceholder_area_shape_exited(_area_id, _area, _area_shape, _local_shape):
	update_texture()
