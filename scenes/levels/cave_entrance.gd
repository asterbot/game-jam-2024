extends Node2D

var can_enter = false

func _process(delta: float) -> void:
	if can_enter and Input.is_action_just_pressed("interact") and not Globals.cookbook_open and not Globals.dialogue_open:
		Transition.change_scene("res://scenes/levels/level_inside/level_inside.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	can_enter = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	can_enter = false