extends Control

@onready var background_editor: Panel = $WindowTemplate/Border/ControlPanelUI/BackgroundEditor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wallpaper_button = preload("res://scenes/wallpaper_button.tscn")
	
	# Generates the buttons for the wallpaper customizer
	for vert in range(8):
		for horiz in range(8):
			var new_button = wallpaper_button.instantiate()
			background_editor.add_child(new_button)
			new_button.position = Vector2 (horiz * 5, vert * 5)
