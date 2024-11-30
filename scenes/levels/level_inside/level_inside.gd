extends AbstractLevel

var ingredients_in_pot = {
	"berries": 0,
	"nuts": 0,
	"tofus": 0,
	"carrots": 0,
	"peppers": 0,
	"mints": 0
}

func _ready() -> void:
	$PotDisplay.modulate.a = 0

func _process(delta: float) -> void:
	pass

# animations when close to pot
func _on_camera_zoom_body_entered(body: Node2D) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "zoom", Vector2(1.55, 1.55), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Camera2D, "position", Vector2(380, 380), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($PotDisplay, "modulate:a", 1, 0.5)
	tween.tween_property($Lights/PotLight, "energy", 1, 0.5)

# animations when leaving pot area
func _on_camera_zoom_body_exited(body: Node2D) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "zoom", Vector2(1.05, 1.05), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Camera2D, "position", Vector2(950, 533), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($PotDisplay, "modulate:a", 0, 0.5)
	tween.tween_property($Lights/PotLight, "energy", 0, 0.5)


func _on_pot_ingredient_collected(ingredient_type: Variant) -> void:
	ingredients_in_pot[ingredient_type] += 1
