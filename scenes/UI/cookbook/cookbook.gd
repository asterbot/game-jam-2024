extends CanvasLayer

func _ready():
	$Cookbook.modulate.a = 0

func make_visible():
	var tween = get_tree().create_tween()
	tween.tween_property($Cookbook, "modulate:a", 1, 0.1)

func make_invisible():
	var tween = get_tree().create_tween()
	tween.tween_property($Cookbook, "modulate:a", 0, 0.1)


func _on_abstract_level_toggle_cookbook_visibility() -> void:
	if Globals.cookbook_open:
		make_visible()
	else:
		make_invisible()
