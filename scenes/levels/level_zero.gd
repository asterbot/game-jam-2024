extends AbstractLevel

func _process(delta: float) -> void:
	# for debugging
	var camera = $Player/Camera2D
	if Input.is_action_just_pressed("debug_zoom_in"):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("debug_zoom_out"):
		camera.zoom = Vector2(max(camera.zoom.x - 0.1, 0.1), max(camera.zoom.y - 0.1, 0.1))
	super(delta)

