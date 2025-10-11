extends Node3D

var grown: bool = false

func _on_button_button_released(button: Variant) -> void:
	if grown == true:
		$"../Macintosh128K/SizeChanger".play("grow")
		grown = false

	elif grown == false:
		$"../Macintosh128K/SizeChanger".play_backwards("grow")
		grown = true
