extends Panel

@onready var logo: TextureButton = $Logo
@onready var file: Button = $File
@onready var edit: Button = $Edit
@onready var view: Button = $View
@onready var special: Button = $Special

@onready var logo_panel: Panel = $Logo/LogoPanel
@onready var file_panel: Panel = $File/FilePanel

var buttons: Array[BaseButton] = []
var active_button: BaseButton = null
var active_panel: Panel = null
var mouse_down := false

func _ready():
	buttons = [logo, file, edit, view, special]

	for btn in buttons:
		btn.toggle_mode = true
		btn.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		btn.mouse_entered.connect(_on_button_mouse_entered.bind(btn))
		btn.mouse_exited.connect(_on_button_mouse_exited.bind(btn))

	for panel in [logo_panel, file_panel]:
		panel.hide()

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_down = event.pressed

		if mouse_down:
			for btn in buttons:
				if btn.get_global_rect().has_point(event.position):
					_set_active(btn)
					break
		else:
			if active_panel:
				active_panel.hide()
			if active_button:
				active_button.button_pressed = false
			active_button = null
			active_panel = null

func _on_button_mouse_entered(btn: BaseButton):
	if mouse_down:
		_set_active(btn)

func _on_button_mouse_exited(btn: BaseButton):
	pass

func _set_active(button: BaseButton):
	if active_button == button:
		return

	if active_button:
		active_button.button_pressed = false
	if active_panel:
		active_panel.hide()

	active_button = button
	active_button.button_pressed = true

	match button:
		logo:
			logo_panel.show(); active_panel = logo_panel
		file:
			file_panel.show(); active_panel = file_panel
		_:
			active_panel = null

	print("Active button: ", active_button.name, " | Active panel: ", active_panel)
