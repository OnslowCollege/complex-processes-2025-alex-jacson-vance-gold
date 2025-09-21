extends MeshInstance3D
func get_image_files_in_folder(path) -> Array:
	var image_files_array = []
	var dir = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir(): # Check if it's a file, not a directory
				var extension = file_name.get_extension().to_lower()
				# Add common image file extensions here
				if extension in ["png", "jpg", "jpeg", "webp", "bmp", "tga", "svg"]:
					image_files_array.append(path + "/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Could not open directory: " + path)

	return image_files_array
func _ready():
	var note_path = "res://assets/models/notetextures/"
	var note_textures = get_image_files_in_folder(note_path)
	var random_note = note_textures[randi() % note_textures.size()]
	random_note = load(random_note)
	var material = self.get_surface_override_material(0)
	material.albedo_texture = random_note
	
