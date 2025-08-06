extends Panel

# Logo Functions
func _on_logo_button_down() -> void:
	$Logo/Panel.visible = true
func _on_logo_button_up() -> void:
	$Logo/Panel.visible = false
