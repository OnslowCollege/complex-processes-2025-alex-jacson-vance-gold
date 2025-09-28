extends Panel

# Initializer for top bar movement
var dragging := false
var drag_offset := Vector2.ZERO
var closed = false

# TitleBar onready variables.
@onready var title_bar: Panel = $Titlebar
@onready var close: TextureButton = $Titlebar/CloseButton
@onready var title: Button = $Titlebar/Title

@onready var ghost_window: Panel = $"../GhostWindow"
@onready var load_animation: AnimationPlayer = $LoadAnimation

@export var app: String = ""

const TITLE_BAR_FOCUSED = preload("uid://c181386vkhtsr")
const TITLE_BAR_UNFOCUSED = preload("uid://cbomexpi4toe7")

# TitleBar dragging code.
func _ready():
	title_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	title_bar.connect("gui_input", _on_title_bar_gui_input)

	ghost_window.visible = false
	
	Globals.open_app_signal.connect(_on_open_app)
	Globals.app_focus_changed.connect(_on_app_focus_changed)


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
					Globals.change_app_focus(app)
					global_position = ghost_window.global_position
					ghost_window.visible = false
					move_to_front()
	elif event is InputEventMouseMotion and dragging:
		ghost_window.global_position += event.relative

# Functions that set up
func _close_window() -> void:
	hide()
	closed = true

func _on_open_app(app_name: String):
	if app == app_name:
		open_app()
		print("Open the Notes app")
	elif app_name == "Calculator":
		print("Open the Calculator app")
	else:
		print("Unknown app:", app_name)

func _on_app_focus_changed(app_name: String):
	var current = title_bar.get_theme_stylebox("panel").duplicate() as StyleBoxTexture
	if app == app_name:
		current.texture = TITLE_BAR_FOCUSED
	if app == "AlarmClock":
		current.texture = TITLE_BAR_UNFOCUSED
	else:
		current.texture = TITLE_BAR_UNFOCUSED
	title_bar.add_theme_stylebox_override("panel", current)
func open_app():
	self.show()
	load_animation.play("load_window")
	ghost_window.visible = false
	move_to_front()

func _on_close_button_pressed() -> void:
	self.hide()


func _process(delta: float) -> void:
	if app == "AlarmClock":
		var current_date_dict = Time.get_datetime_dict_from_system()
		title.text = str(current_date_dict.hour) + " : " + str(current_date_dict.minute) + " : " + str(current_date_dict.second)
