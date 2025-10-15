extends Node

signal open_app_signal(app_name: String)
signal app_focus_changed(app_name: String)
signal play_chime
var volume: float = 1.0

func open_app(app_name: String):
	open_app_signal.emit(app_name)

func change_app_focus(app_name: String):
	app_focus_changed.emit(app_name)

func signal_chime():
	play_chime.emit()
	
