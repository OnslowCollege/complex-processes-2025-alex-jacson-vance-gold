extends Node3D

# ========================================================= #
#                 SECTION A: MOUSE & KEYBOARD               #
# ========================================================= #

@onready var mouse: XRToolsPickable = $"Mouse&Keyboard/MousePad/Mouse"
@onready var cursor: AnimatedSprite2D = $Table/Macintosh128K/Screen/Source/OS/Cursor
@onready var subviewport: SubViewport = $Table/Macintosh128K/Screen/Source

var is_mouse_down := false
var held_button_index := MOUSE_BUTTON_LEFT
var held_button_mask := 0
var last_vp_pos := Vector2.ZERO
var last_pos_initialized := false

func _ready() -> void:
	subviewport.gui_disable_input = false
	subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface:
		xr_interface.pose_recentered.connect(_on_pose_recentered)
		xr_interface.session_visible.connect(_on_session_visible)

	await get_tree().create_timer(0.15).timeout


# --- Mouse interaction ---
func _on_mouse_clicked(pickable: Variant) -> void:
	$"Mouse&Keyboard/MousePad/Mouse/ClickDown".play()
	simulate_mouse_press(cursor.position)

func _on_mouse_released(pickable: Variant) -> void:
	$"Mouse&Keyboard/MousePad/Mouse/ClickUp".play()
	simulate_mouse_release(cursor.position)
	

func _process(delta: float) -> void:
	var mouse3Dpos = mouse.position * 2 
	var mouse2Dpos = Vector2(mouse3Dpos.x, mouse3Dpos.z)
	cursor.position = mouse2Dpos * 1024

	var pos := cursor.position
	if not last_pos_initialized:
		last_vp_pos = pos
		last_pos_initialized = true
	simulate_mouse_motion(pos)

func simulate_mouse_motion(position: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.relative = position - last_vp_pos
	motion.button_mask = held_button_mask
	subviewport.push_input(motion)
	last_vp_pos = position

func simulate_mouse_press(position: Vector2, button_index: int = MOUSE_BUTTON_LEFT) -> void:
	is_mouse_down = true
	held_button_index = button_index
	held_button_mask = 1 << (button_index - 1)

	var hover := InputEventMouseMotion.new()
	hover.position = position
	hover.relative = Vector2.ZERO
	hover.button_mask = 0
	subviewport.push_input(hover)
	last_vp_pos = position
	last_pos_initialized = true

	var down := InputEventMouseButton.new()
	down.position = position
	down.button_index = button_index
	down.pressed = true
	down.button_mask = held_button_mask
	subviewport.push_input(down)

func simulate_mouse_release(position: Vector2, button_index: int = MOUSE_BUTTON_LEFT) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = position
	motion.relative = position - last_vp_pos
	motion.button_mask = held_button_mask
	subviewport.push_input(motion)
	last_vp_pos = position

	var up := InputEventMouseButton.new()
	up.position = position
	up.button_index = button_index
	up.pressed = false
	up.button_mask = 0
	subviewport.push_input(up)

	is_mouse_down = false
	held_button_mask = 0

	var hover := InputEventMouseMotion.new()
	hover.position = position
	hover.relative = Vector2.ZERO
	hover.button_mask = 0
	subviewport.push_input(hover)


# ========================================================= #
#              SECTION B: XR PLAYER RECENTERING             #
# ========================================================= #

@onready var xr_origin: XROrigin3D = $XROrigin3D
@onready var xr_camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var booth_origin: Node3D = $BoothOrigin   # can stay at floor level Y = 0

var initial_hmd_height: float = 0.0  # will store HMD starting Y

func _on_session_visible() -> void:
	# Get initial HMD height
	initial_hmd_height = xr_camera.global_transform.origin.y if xr_camera and xr_camera.global_transform else 0.35


	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)
	await get_tree().create_timer(0.08).timeout
	reset_player_to_booth()

func _on_pose_recentered() -> void:
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)
	await get_tree().create_timer(0.06).timeout
	reset_player_to_booth()


func reset_player_to_booth() -> void:
	if not xr_camera or not booth_origin:
		return

	var cam_world: Transform3D = xr_camera.global_transform
	var booth_world: Transform3D = booth_origin.global_transform
	var new_t: Transform3D = xr_origin.global_transform

	# --- XZ alignment only ---
	var delta: Vector3 = cam_world.origin - booth_world.origin
	delta.y = 0
	new_t.origin.x -= delta.x
	new_t.origin.z -= delta.z

	# --- Rotation (yaw only) ---
	var cam_forward: Vector3 = -cam_world.basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()

	var booth_forward: Vector3 = -booth_world.basis.z
	booth_forward.y = 0
	booth_forward = booth_forward.normalized()

	var angle: float = booth_forward.signed_angle_to(cam_forward, Vector3.UP)
	var rot: Basis = Basis(Vector3.UP, -angle)

	# Rotate around booth origin horizontally
	var rel: Vector3 = new_t.origin - booth_world.origin
	rel.y = 0
	rel = rot * rel
	new_t.origin.x = booth_world.origin.x + rel.x
	new_t.origin.z = booth_world.origin.z + rel.z

	# --- Apply HMD starting height so player is never in floor ---
	new_t.origin.y = initial_hmd_height

	new_t.basis = rot * new_t.basis
	xr_origin.global_transform = new_t


# ---------- Input merge ---------- #
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		subviewport.push_input(event)
#	if event.is_action_pressed("reset"):
#		reset_player_to_booth()
