extends MeshInstance3D

var textures: Array = [
load("res://assets/textures/Pictures/coconut.jpg"), 
load("res://assets/textures/Pictures/hornetdrip.jpg"), 
load("res://assets/textures/Pictures/miku.jpg"),
load("res://assets/textures/Pictures/pearto.jpg"),
load("res://assets/textures/Pictures/monkey.png"),
load("res://assets/textures/Pictures/penguin.png"),
load("res://assets/textures/Pictures/luffy.png")]

func _ready():
	var random_texture = textures[randi() % textures.size()]
	self.mesh.material.albedo_texture = random_texture
