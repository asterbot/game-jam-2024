extends Control

@onready var labels = {
	"berries": %BerryContainer/Label,
	"nuts": %NutContainer/Label,
	"tofus": %TofuContainer/Label,
	"carrots": %CarrotContainer/Label,
	"peppers": %PepperContainer/Label,
	"mints": %MintContainer/Label
}

func _on_pot_ingredient_collected(ingredient_type: Variant) -> void:
	labels[ingredient_type].text = str(int(labels[ingredient_type].text) + 1)

func _ready() -> void:
	var ingredient_names = labels.keys()
	var containers = $HBoxContainer.get_children()

	for index in range(ingredient_names.size()):
		if not Globals.ingredients[ingredient_names[index]]["discovered"]:
			containers[index].get_child(0).set_texture(Globals.index_sprite_map[0])
