extends Panel

@onready var date: RichTextLabel = $"../Image/Date"
@onready var time: RichTextLabel = $"../Image/Time"
@onready var wallpaper_rect: TextureRect = $"../../Wallpaper"
@onready var confirm_button: TextureButton = $"../Image/ConfirmButton"
@onready var pixel_grid: GridContainer = $"../Image/PixelGrid"
const GRID_SIZE = 8
var image: Image
var texture: ImageTexture
var buttons := []            # [Button, ColorRect]
var mouse_down := false
var current_color := Color(0,0,0,1) # painting color
var toggled_this_drag := {}  # track which buttons have already toggled this drag

func _ready():
	# Initialize checkerboard image
	image = Image.create(GRID_SIZE, GRID_SIZE, false, Image.FORMAT_RGBA8)
	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var color = Color(0,0,0,1) if (x + y) % 2 == 0 else Color(1,1,1,1)
			image.set_pixel(x, y, color)

	# Create wallpaper texture
	texture = ImageTexture.create_from_image(image)
	wallpaper_rect.texture = texture

	# Create 8x8 buttons inside the grid
	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var btn = Button.new()
			btn.text = ""
			btn.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
			btn.remove_theme_stylebox_override("Focus")
			btn.focus_mode = Control.FOCUS_NONE
			btn.custom_minimum_size = Vector2(4, 4)
			

			var color_rect = ColorRect.new()
			color_rect.color = image.get_pixel(x, y)
			color_rect.anchor_left = 0
			color_rect.anchor_top = 0
			color_rect.anchor_right = 1
			color_rect.anchor_bottom = 1
			color_rect.offset_left = 0
			color_rect.offset_top = 0
			color_rect.offset_right = 0
			color_rect.offset_bottom = 0
			color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			btn.add_child(color_rect)

			btn.button_down.connect(Callable(self, "_on_pixel_pressed_down").bind(x, y))
			btn.mouse_entered.connect(Callable(self, "_on_pixel_hovered").bind(x, y))

			pixel_grid.add_child(btn)
			buttons.append([btn, color_rect])

	confirm_button.pressed.connect(Callable(self, "_on_confirm_pressed"))

func _input(event):
	if event is InputEventMouseButton:
		mouse_down = event.pressed
		if not mouse_down:
			toggled_this_drag.clear()

# Mouse-down toggles color
func _on_pixel_pressed_down(x: int, y: int):
	var index = y * GRID_SIZE + x
	var old_color = image.get_pixel(x, y)
	current_color = Color(1,1,1,1) if old_color == Color(0,0,0,1) else Color(0,0,0,1)
	paint_pixel(x, y)

# Hover while dragging
func _on_pixel_hovered(x: int, y: int):
	if mouse_down:
		paint_pixel(x, y)

# Paint helper
func paint_pixel(x: int, y: int):
	var index = y * GRID_SIZE + x
	if toggled_this_drag.has(index):
		return
	toggled_this_drag[index] = true

	buttons[index][1].color = current_color
	image.set_pixel(x, y, current_color)

# Confirm changes to wallpaper
func _on_confirm_pressed():
	texture = ImageTexture.create_from_image(image)
	wallpaper_rect.texture = texture

func _process(_delta: float) -> void:
	var current_date_dict = Time.get_datetime_dict_from_system()
	var year = int(str(current_date_dict.year).substr(2))
	date.text = str(current_date_dict.day) + " / " + str(current_date_dict.month) + " / " + str(year)
	time.text = str(current_date_dict.hour) + " : " + str(current_date_dict.minute) + " : " + str(current_date_dict.second)
	texture = ImageTexture.create_from_image(image)
	confirm_button.texture_normal = texture
