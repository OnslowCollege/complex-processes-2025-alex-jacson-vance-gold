extends Node

signal open_app_signal(app_name: String)

func open_app(app_name: String):
	open_app_signal.emit(app_name)
