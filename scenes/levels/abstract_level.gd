extends Node2D

class_name AbstractLevel

signal toggle_cookbook_visibility()

func _ready():
	$Cookbook.visible = true
	$UI.visible = true
	$UI.update_all()
	pass

func _process(_delta):
	if Input.is_action_just_pressed("cookbook") and not Globals.dialogue_open:
		Globals.cookbook_open = not Globals.cookbook_open
		toggle_cookbook_visibility.emit()
	
	# for debugging
	var camera = $Player/Camera2D
	if Input.is_action_just_pressed("debug_zoom_in"):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("debug_zoom_out"):
		camera.zoom = Vector2(max(camera.zoom.x - 0.1, 0.1), max(camera.zoom.y - 0.1, 0.1))
