extends Area2D

signal clicked()

const ACTIVE_TEXTURE = preload("res://grid/grid_placeholder_active.png")
const INACTIVE_TEXTURE = preload("res://grid/grid_placeholder.png")

var active: bool = false
onready var game_node = $"../../.."

func _ready():
	connect("clicked", game_node, "_on_grid_placeholder_clicked", [self])
	update_texture()

func update_texture():
	$Sprite.texture = ACTIVE_TEXTURE if active else INACTIVE_TEXTURE

func _input(event):
	if not active:
		return
	
	if event.is_action_pressed("grid_click"):
		emit_signal("clicked")

func _on_GridPlaceholder_mouse_entered():
	active = true
	update_texture()

func _on_GridPlaceholder_mouse_exited():
	active = false
	update_texture()
