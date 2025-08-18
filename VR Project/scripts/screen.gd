extends Node3D

var mesh_size
@onready var source: SubViewport = $Source
@onready var display: Sprite3D = $Display
@onready var touch_area: Area3D = $Display/Area3D

var is_mouse_held = false
var is_mouse_inside = false
var last_mouse_position3D = null
var last_mouse_position2D = null

func _ready() -> void:
	pass

func _mouse_entered_touch_area():
	is_mouse_inside = true
