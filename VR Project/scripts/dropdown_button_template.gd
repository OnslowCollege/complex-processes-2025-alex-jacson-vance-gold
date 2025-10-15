extends Button

@export var connected_app: String
@export var has_functionality: bool

@onready var top_bar_button: BaseButton = $"../../.."


func _ready():
	# Connect the button's "pressed" signal to a function
	self.pressed.connect(_on_my_button_pressed)

func _on_my_button_pressed():
	
	if has_functionality == false: Globals.signal_chime()
	else: pass
	
	Globals.open_app(self.connected_app)
	top_bar_button.button_pressed = false
