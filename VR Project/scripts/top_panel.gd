extends Control

@onready var logo: TextureButton = $Logo
@onready var file: Button = $File
@onready var edit: Button = $Edit
@onready var view: Button = $View
@onready var special: Button = $Special

var panels: Dictionary = {}        # maps buttons → panels
var current: BaseButton = null

func _ready():
	# Collect panels dynamically (if they exist under the button)
	for btn in [logo, file, edit, view, special]:
		var panel = btn.get_node_or_null("Panel")
		if panel:
			panels[btn] = panel
			panel.hide() # hide at startup

# --------------------------
# Toggle handlers
func _on_logo_toggled(toggled_on: bool) -> void:
	_handle_toggle(logo, toggled_on)

func _on_file_toggled(toggled_on: bool) -> void:
	_handle_toggle(file, toggled_on)

func _on_edit_toggled(toggled_on: bool) -> void:
	_handle_toggle(edit, toggled_on)

func _on_view_toggled(toggled_on: bool) -> void:
	_handle_toggle(view, toggled_on)

func _on_special_toggled(toggled_on: bool) -> void:
	_handle_toggle(special, toggled_on)

# --------------------------
func _handle_toggle(btn: BaseButton, toggled_on: bool) -> void:
	if toggled_on:
		reset_panels(btn)
		if btn in panels:
			panels[btn].show()
		current = btn
	else:
		if btn in panels:
			panels[btn].hide()
		current = null

func reset_panels(new_btn: BaseButton) -> void:
	# hide all panels
	for panel in panels.values():
		panel.hide()

	# untoggle all buttons except the one just pressed
	for btn in panels.keys():
		if btn != new_btn:
			btn.button_pressed = false

# --------------------------
# Close panels when clicking outside
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()

		var clicked_inside := false

		# Check if mouse is over a button or its panel
		for btn in panels.keys():
			if btn.get_global_rect().has_point(mouse_pos):
				clicked_inside = true
				break
			if panels[btn].visible and panels[btn].get_global_rect().has_point(mouse_pos):
				clicked_inside = true
				break

		# If not inside any button/panel → close everything
		if not clicked_inside:
			_clear_all()

func _clear_all() -> void:
	for btn in panels.keys():
		btn.button_pressed = false
		panels[btn].hide()
	current = null
