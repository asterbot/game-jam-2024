extends AbstractLevel

var can_cook = false

var ingredients_in_pot = {
	"berries": 0,
	"nuts": 0,
	"tofus": 0,
	"carrots": 0,
	"peppers": 0,
	"mints": 0
}

var level_criteria = {
	1:{
		"berries": 3,
		"nuts": 3,
		"tofus": 3,
		"carrots": 0,
		"peppers": 0,
		"mints": 0
	},
	2:{
		"berries": 4,
		"nuts": 0,
		"tofus": 4,
		"carrots": 0,
		"peppers": 0,
		"mints": 4
	},
	3:{
		"berries": 0,
		"nuts": 6,
		"tofus":0,
		"carrots": 3,
		"peppers": 3,
		"mints": 0
	}
}

func is_pass(level: int):
	var criteria = level_criteria[level]
	for item in ingredients_in_pot:
		if ingredients_in_pot[item] < criteria[item]:
			return false
	return true

func _ready() -> void:
	$PotDisplay.modulate.a = 0
	Globals.ingredients["berries"]["amount"] = 100
	super()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_cook and Globals.curr_level!=0:
		print(ingredients_in_pot)
		if is_pass(Globals.curr_level):
			print("passed!!!")
			Globals.start_dialogue(str(Globals.curr_level)+"_pass")
			Globals.curr_level += 1
		else:
			Globals.start_dialogue("fail")
	super(delta)

# animations when close to pot
func _on_camera_zoom_body_entered(_body: Node2D) -> void:
	can_cook = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "zoom", Vector2(1.55, 1.55), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Camera2D, "position", Vector2(380, 380), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($PotDisplay, "modulate:a", 1, 0.5)
	tween.tween_property($Lights/PotLight, "energy", 1, 0.5)

# animations when leaving pot area
func _on_camera_zoom_body_exited(_body: Node2D) -> void:
	can_cook = false
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "zoom", Vector2(1.05, 1.05), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Camera2D, "position", Vector2(950, 533), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($PotDisplay, "modulate:a", 0, 0.5)
	tween.tween_property($Lights/PotLight, "energy", 0, 0.5)


func _on_pot_ingredient_collected(ingredient_type: Variant) -> void:
	ingredients_in_pot[ingredient_type] += 1
