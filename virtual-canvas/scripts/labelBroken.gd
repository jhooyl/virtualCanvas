extends Label

@onready var camera = get_viewport().get_camera_2d()

func _process(delta):
	if camera:
		global_position = camera.global_position
