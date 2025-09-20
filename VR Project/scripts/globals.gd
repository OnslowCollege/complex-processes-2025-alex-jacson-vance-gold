extends Node

signal open_app_signal(app_name)

func open_app(app_name: String) -> void:
	emit_signal("open_app_signal", app_name)
	print("Opening app:", app_name)
