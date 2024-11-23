extends HBoxContainer

@onready var selection_map = {
	1: $BerrySlot,
	2: $NutSlot,
	3: $TofuSlot,
	4: $CarrotSlot,
	5: $PepperSlot,
	6: $MintSlot
} 

func receive_data_from_ui(ingredient: String) -> void:
	"""Receives ingredient name from ui.gd and passes to inventory slots"""
	var ingredient_info = Globals.ingredients[ingredient]
	var inventory_slot = ingredient_info["inventory_slot"]
	selection_map[inventory_slot].set_amount(ingredient_info["amount"])
	selection_map[inventory_slot].set_image(inventory_slot)

func provide_selected_ingredient()->String:
	return Globals.index_ingredient_map[Globals.selected_index_ui]


func _process(_delta: float) -> void:
	for slot in selection_map:
		selection_map[slot].selected = false


	var actions: Array[String] = ["berry_select","nut_select","tofu_select","carrot_select","pepper_select","mint_select"]
	var index: int = 1 # keep track of index as loop through, instead of finding index later
	for action in actions:
		if Input.is_action_just_pressed(action):
			Globals.selected_index_ui = index
			break
		index += 1
	
	if Input.is_action_just_pressed("inventory_left"):
		Globals.selected_index_ui -= 1
	if Input.is_action_just_pressed("inventory_right"):
		Globals.selected_index_ui += 1

	if Globals.selected_index_ui > Globals.max_index:
		Globals.selected_index_ui = 1
	if Globals.selected_index_ui < 1:
		Globals.selected_index_ui = Globals.max_index

	selection_map[Globals.selected_index_ui].selected = true
