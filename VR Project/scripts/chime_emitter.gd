extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.play_chime.connect(_on_chime)
	
func _on_chime():
	volume_linear = Globals.volume
	play()
