extends Control

@onready var labels = {
	"berries": %BerryLabel,
	"nuts": %NutLabel,
	"tofus": %TofuLabel,
	"carrots": %CarrotLabel,
	"peppers": %PepperLabel,
	"mints": %MintLabel
}

func _on_pot_ingredient_collected(ingredient_type: Variant) -> void:
	labels[ingredient_type].text = str(int(labels[ingredient_type].text) + 1)
