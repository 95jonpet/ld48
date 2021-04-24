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
	$Sprite.texture = ACTIVE_TEXTURE if is_clickable() else INACTIVE_TEXTURE

func is_clickable() -> bool:
	return (
		active
		and get_overlapping_bodies().empty()
		and get_overlapping_areas().empty()
	)

func _input(event):
	if not is_clickable():
		return
	
	if event.is_action_pressed("grid_click"):
		emit_signal("clicked")

func _process(_delta):
	update_texture()

func _on_GridPlaceholder_mouse_entered():
	active = true
	update_texture()

func _on_GridPlaceholder_mouse_exited():
	active = false
	update_texture()
