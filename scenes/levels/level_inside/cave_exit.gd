extends Area2D

var can_leave = false

var level_scene_map = {
	0: "res://scenes/levels/level_zero.tscn",
	1: "res://scenes/levels/level_one.tscn",
	2: "res://scenes/levels/level_two.tscn",
	3: "res://scenes/levels/level_three.tscn",	
}


func _ready():
	$Key/Sprite2D.set_texture(preload("res://assets/keys/letters/e_key.png"))
	$Key.visible = false

func _process(_delta):
	if can_leave and Input.is_action_just_pressed("interact") and not Globals.cookbook_open and not Globals.dialogue_open:
		if Globals.curr_level == 0:
			Globals.curr_level += 1
		Transition.change_scene(level_scene_map[Globals.curr_level])
		print("got here")
		Globals.dialogue_state = str(Globals.curr_level) + "_idle"

func _on_body_entered(_body: Node2D) -> void:
	if Globals.curr_level > 0:
		if Globals.dialogues[str(Globals.curr_level - 1)+"_pass"]["completed"] :
			can_leave = true
			$Key.visible = true
	elif (Globals.curr_level==0 and Globals.dialogues["0_pass"]["completed"]):
		can_leave=true
		$Key.visible = true

func _on_body_exited(_body: Node2D) -> void:	
	can_leave = false
	$Key.visible = false
