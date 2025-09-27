extends Control

#func _input(event: InputEvent) -> void:
#	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
#		print("mouse button pressed")

var app: String = ""
@onready var about_mac: TextureButton = $AboutMac

func _ready() -> void:
	Globals.open_app_signal.connect(_on_open_app)
	
func _on_open_app(app_name: String):
	if "About" == app_name:
		about_mac.show()
	else:
		pass

# Handle about close.
func _input(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var button_rect = about_mac.get_global_rect()
			if not button_rect.has_point(event.position):
				about_mac.hide()
