extends Node2D

var can_enter = false

func _ready():
	$Key/Sprite2D.set_texture(preload("res://assets/keys/letters/e_key.png"))
	$Key.visible = false

func _process(_delta: float) -> void:
	if can_enter and Input.is_action_just_pressed("interact") and not Globals.cookbook_open and not Globals.dialogue_open:
		Transition.change_scene("res://scenes/levels/level_inside/level_inside.tscn")
		if not Globals.dialogue_triggered[Globals.curr_level]:
			Globals.dialogue_triggered[Globals.curr_level] = true
			if Globals.curr_level==0:
				Globals.dialogue_state = str(Globals.curr_level) + "_pass"


func _on_area_2d_body_entered(_body: Node2D) -> void:
	can_enter = true
	$Key.visible = true
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	can_enter = false
	$Key.visible = false
