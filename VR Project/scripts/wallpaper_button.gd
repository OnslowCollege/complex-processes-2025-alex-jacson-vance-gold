extends TextureButton

func coods(horiz, vert):
	var coordinates = [horiz, vert]
	# Calculates co-ordinates into the position of the button
	if vert % 2 == 0:
		self.button_pressed = true
		if horiz % 2 != 0:
			self.button_pressed = false
	else:
		self.button_pressed = false
		if horiz % 2 != 0:
			self.button_pressed = true
	# Returns the co-ordinates
	return coordinates
