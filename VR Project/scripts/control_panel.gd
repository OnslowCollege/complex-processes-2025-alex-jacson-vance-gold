extends Panel

@onready var background_editor: Panel = $"../Image/BackgroundEditor"
@onready var date: RichTextLabel = $"../Image/Date"
@onready var time: RichTextLabel = $"../Image/Time"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wallpaper_button = preload("res://scenes/wallpaper_button.tscn")
	
	# Generates the buttons for the wallpaper customizer
	for vert in range(8):
		for horiz in range(8):
			var new_button = wallpaper_button.instantiate()
			background_editor.add_child(new_button)
			new_button.position = Vector2 (horiz * 5, vert * 5)
			new_button.coods(horiz, vert)

func _process(_delta: float) -> void:
	var current_date_dict = Time.get_datetime_dict_from_system()
	var year = int(str(current_date_dict.year).substr(2))
	date.text = str(current_date_dict.day) + " / " + str(current_date_dict.month) + " / " + str(year)
	time.text = str(current_date_dict.hour) + " : " + str(current_date_dict.minute) + " : " + str(current_date_dict.second)
