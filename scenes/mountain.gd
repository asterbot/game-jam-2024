extends Node2D


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# for debugging
	var camera = $Player/Camera2D
	if Input.is_action_just_pressed("debug_zoom_in"):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("debug_zoom_out"):
		camera.zoom = Vector2(max(camera.zoom.x - 0.1, 0.1), max(camera.zoom.y - 0.1, 0.1))
		
	
	pass
	#var berries = $Bush/Ingredients.get_children()
	#for b in berries:
		#print(b.position)
		#print(b.global_position)
	#print($Player.global_position)
	#print()
