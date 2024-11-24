extends Node2D

var player_in_range: bool = false


func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("pick_up"):
		queue_free()
		Globals.respawn_pos = Globals.DEFAULT_RESPAWN_POS


func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_range = true
	$Label.visible = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_range = false
	$Label.visible = false
