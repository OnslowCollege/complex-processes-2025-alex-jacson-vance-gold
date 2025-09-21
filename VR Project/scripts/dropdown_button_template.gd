extends Button

@export var connected_app: String

@onready var top_bar_button: BaseButton = $"../../.."


func _ready():
	# Connect the button's "pressed" signal to a function
	self.pressed.connect(_on_my_button_pressed)

func _on_my_button_pressed():
	Globals.open_app(self.connected_app)
	top_bar_button.button_pressed = false
