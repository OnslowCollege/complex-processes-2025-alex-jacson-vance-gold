extends Node3D

@export var key_name: String
@onready var letter: Label3D = $InteractableAreaButton/Text

const key_map = {
	"`": KEY_QUOTELEFT,
	"1": KEY_1, "2": KEY_2, "3": KEY_3, "4": KEY_4, "5": KEY_5,
	"6": KEY_6, "7": KEY_7, "8": KEY_8, "9": KEY_9, "0": KEY_0,
	"-": KEY_MINUS, "=": KEY_EQUAL, "Backspace": KEY_BACKSPACE,
	"Tab": KEY_TAB, "q": KEY_Q, "w": KEY_W, "e": KEY_E, "r": KEY_R,
	"t": KEY_T, "y": KEY_Y, "u": KEY_U, "i": KEY_I, "o": KEY_O,
	"p": KEY_P, "[": KEY_BRACKETLEFT, "]": KEY_BRACKETRIGHT,
	"|": KEY_BACKSLASH, "Capslock": KEY_CAPSLOCK,
	"a": KEY_A, "s": KEY_S, "d": KEY_D, "f": KEY_F, "g": KEY_G,
	"h": KEY_H, "j": KEY_J, "k": KEY_K, "l": KEY_L,
	";": KEY_SEMICOLON, "'": KEY_APOSTROPHE, "Return": KEY_ENTER,
	"Shift": KEY_SHIFT, "z": KEY_Z, "x": KEY_X, "c": KEY_C,
	"v": KEY_V, "b": KEY_B, "n": KEY_N, "m": KEY_M,
	",": KEY_COMMA, ".": KEY_PERIOD, "/": KEY_SLASH,
	"RShift": KEY_SHIFT, "Options": KEY_ALT, "Mac": KEY_META,
	"Spacebar": KEY_SPACE, "Enter": KEY_ENTER, "Roptions": KEY_ALT
}

func _ready() -> void:
	letter.text = key_name

func _on_key_pressed(button: Variant) -> void:
	$keypresssound.play()
	call_deferred("send_fake_input")

func send_fake_input():
	var ev := InputEventKey.new()
	ev.keycode = key_map.get(key_name, KEY_UNKNOWN)
	ev.unicode = int(key_name.unicode_at(0)) 
	ev.pressed = true
	Input.parse_input_event(ev)

	var ev_up := ev.duplicate()
	ev_up.pressed = false
	Input.parse_input_event(ev_up)
