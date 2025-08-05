extends Node3D

@onready var keys_location: Node3D = $Keys

const keys = ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "+", "Backspace", 
			"Tab", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "Backslash",
			"Caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "Quote", "Return",
			"LShift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "RShift",
			"Loptions", "Mac", "Spacebar", "Enter", "Roptions"]

const x_layers = [14, 14, 13, 12, 5]
const y_layers = 5

func _ready() -> void:
	var key_template = preload("res://scenes/key_template.tscn")
	var layer_counter = 2
	for horiz in range(14):
		for vert in range(y_layers):
			var new_key = key_template.instantiate()
			keys_location.add_child(new_key)
			new_key.position = Vector3(-1.392 + float(x_layers[0]) * 0.01, 0.315, -0.39 + float(y_layers) * 0.01 )
			
	
