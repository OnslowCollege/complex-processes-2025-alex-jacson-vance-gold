extends Control

# Initializer for top bar movement
var dragging := false
var drag_offset := Vector2.ZERO
var closed = false

# TitleBar onready variables.
@onready var title_bar: Panel = $Titlebar
@onready var close: TextureButton = $Titlebar/CloseButton

# TitleBar dragging code.
func _ready():
	title_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	title_bar.connect("gui_input", _on_title_bar_gui_input)
	

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		move_to_front()
		if event.pressed:
			dragging = true
			drag_offset = event.position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position += event.relative

# Functions that set up
func _close_window() -> void:
	hide()
	closed = true
	pass # Replace with function body.
