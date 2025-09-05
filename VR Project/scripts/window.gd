extends Panel

# Initializer for top bar movement
var dragging := false
var drag_offset := Vector2.ZERO
var closed = false

# TitleBar onready variables.
@onready var title_bar: Panel = $Titlebar
@onready var close: TextureButton = $Titlebar/CloseButton

@onready var ghost_window: Panel = $"../GhostWindow"
@onready var load_animation: AnimationPlayer = $LoadAnimation

# TitleBar dragging code.
func _ready():
	title_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	title_bar.connect("gui_input", _on_title_bar_gui_input)

	ghost_window.visible = false

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.pressed:
			dragging = true
			drag_offset = event.position
			
			ghost_window.global_position = global_position
			ghost_window.size = size
			ghost_window.visible = true
			
		else:
			dragging = false
			if ghost_window.visible:
					load_animation.play("load_window")
					global_position = ghost_window.global_position
					ghost_window.visible = false
					move_to_front()
	elif event is InputEventMouseMotion and dragging:
		ghost_window.global_position += event.relative

# Functions that set up
func _close_window() -> void:
	hide()
	closed = true
