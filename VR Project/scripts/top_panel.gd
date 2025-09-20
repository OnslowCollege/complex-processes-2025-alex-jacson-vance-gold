extends Control

var buttons = []         # top-level menu buttons
var active_button = null
var mouse_down = false

func _ready():
	# collect top-level menu buttons
	for child in get_children():
		if child is BaseButton:
			buttons.append(child)
	# hide all panels initially and connect sub-buttons
	for btn in buttons:
		var panel = btn.get_node_or_null("Panel")
		if panel:
			panel.visible = false
			_connect_sub_buttons(panel)

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_down = true
	else:
		if mouse_down and active_button:
			print("Activated:", active_button.name)
		mouse_down = false
		_clear_active()

	# check mouse over top-level buttons
	var mouse_pos = get_global_mouse_position()
	if mouse_down:
		for btn in buttons:
			var rect = btn.get_global_rect()
			if rect.has_point(mouse_pos):
				if active_button != btn:
					_set_active(btn)
				break

# --------------------------
func _set_active(btn):
	# hide previous panel
	if active_button and active_button != btn:
		var old_panel = active_button.get_node_or_null("Panel")
		if old_panel:
			old_panel.visible = false

	active_button = btn

	# show new panel
	var panel = btn.get_node_or_null("Panel")
	if panel:
		panel.visible = true

	print("Active:", active_button.name)

func _clear_active():
	for btn in buttons:
		var panel = btn.get_node_or_null("Panel")
		if panel:
			panel.visible = false
	active_button = null

# --------------------------
# recursively connect mouse_entered or pressed signals for all sub-buttons in a panel
func _connect_sub_buttons(node):
	for child in node.get_children():
		if child is BaseButton:
			# hover print
			child.mouse_entered.connect(func():
				print("Hovering over:", child.name))
			# pressed -> trigger Globals.open_app
			child.pressed.connect(func():
				if Globals.has_method("open_app"):
					Globals.open_app(child.name))
		else:
			_connect_sub_buttons(child)
