extends XRToolsPickable

@onready var floppy_snapzone: XRToolsSnapZone = $Mesh/FloppyDiskSnapZone

var floppy

func on_floppy_loaded():
	pass

func on_floppy_ejected():
	floppy_snapzone.drop_object()
	
	floppy = null


func _on_floppy_disk_snap_zone_has_picked_up(what: Variant) -> void:
	$AnimationPlayer.play("LoadFloppy")
	
	floppy = what

func _process(delta):
	if is_picked_up() and get_picked_up_by_controller() and get_picked_up_by_controller().is_button_pressed("by_button"):
		if floppy:
			$AnimationPlayer.play("EjectFloppy")
