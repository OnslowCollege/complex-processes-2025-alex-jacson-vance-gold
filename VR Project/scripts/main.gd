extends Node3D

@onready var mouse: XRToolsPickable = $"Mouse&Keyboard/MousePad/Mouse"
@onready var cursor: AnimatedSprite2D = $Table/Macintosh128K/Screen/Source/OS/Cursor
@onready var subviewport: SubViewport = $Table/Macintosh128K/Screen/Source

var is_mouse_down := false
var held_button_index := MOUSE_BUTTON_LEFT
var held_button_mask := 0
var last_vp_pos := Vector2.ZERO
var last_pos_initialized := false

func _ready() -> void:
	# Make sure the SubViewport actually takes input and keeps updating.
	subviewport.gui_disable_input = false
	subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

func _on_mouse_clicked(pickable: Variant) -> void:
	# Start hold at current cursor position
	var pos := cursor.position
	simulate_mouse_press(pos)

func _on_mouse_released(pickable: Variant) -> void:
	# End hold at current cursor position
	var pos := cursor.position
	simulate_mouse_release(pos)

func _process(delta: float) -> void:
	# Update your 2D cursor from the 3D mouse
	var mouse3Dpos = mouse.position
	var mouse2Dpos = Vector2(mouse3Dpos.x, mouse3Dpos.z)
	cursor.position = mouse2Dpos * 1024

	# Send motion every frame so UI sees hover/drag.
	var pos := cursor.position
	if not last_pos_initialized:
		last_vp_pos = pos
		last_pos_initialized = true

	simulate_mouse_motion(pos)

# --- Input synthesis helpers ---

func simulate_mouse_motion(position: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.relative = position - last_vp_pos         # critical for drag
	motion.button_mask = held_button_mask            # non-zero while held
	subviewport.push_input(motion)
	last_vp_pos = position

func simulate_mouse_press(position: Vector2, button_index: int = MOUSE_BUTTON_LEFT) -> void:
	is_mouse_down = true
	held_button_index = button_index
	held_button_mask = 1 << (button_index - 1)

	# Prime hover at this position (mask 0) so focus/hover is correct
	var hover := InputEventMouseMotion.new()
	hover.position = position
	hover.relative = Vector2.ZERO
	hover.button_mask = 0
	subviewport.push_input(hover)
	last_vp_pos = position
	last_pos_initialized = true

	# Actual press
	var down := InputEventMouseButton.new()
	down.position = position
	down.button_index = button_index
	down.pressed = true
	down.button_mask = held_button_mask
	subviewport.push_input(down)

func simulate_mouse_release(position: Vector2, button_index: int = MOUSE_BUTTON_LEFT) -> void:
	# Send a final motion with the button still held, so drop targets get the last delta
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.relative = position - last_vp_pos
	motion.button_mask = held_button_mask
	subviewport.push_input(motion)
	last_vp_pos = position

	# Release
	var up := InputEventMouseButton.new()
	up.position = position
	up.button_index = button_index
	up.pressed = false
	up.button_mask = 0
	subviewport.push_input(up)

	# Clear state and send a hover with no buttons held
	is_mouse_down = false
	held_button_mask = 0

	var hover := InputEventMouseMotion.new()
	hover.position = position
	hover.relative = Vector2.ZERO
	hover.button_mask = 0
	subviewport.push_input(hover)
