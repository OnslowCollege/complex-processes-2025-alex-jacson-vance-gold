extends Node2D

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode != KEY_ENTER:
			$Control/Text.text = OS.get_keycode_string(event.keycode)
			print(OS.get_keycode_string(event.keycode))
