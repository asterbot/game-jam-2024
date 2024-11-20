extends HBoxContainer

var select_index = 1;


@onready var selection_map = {
	1: $BerrySlot,
	2: $NutSlot,
	3: $TofuSlot,
	4: $CarrotSlot,
	5: $PepperSlot,
	6: $MintSlot
} 

var max_ingredients = 0 # set in _ready()

func receive_data_from_ui(items: Dictionary) -> void:
	"""Receives data from ui.gd and passes to inventory slots"""
	for item in items:
		selection_map[items[item]["inventory_slot"]].set_qty(items[item]["amount"])
		selection_map[items[item]["inventory_slot"]].discovered = items[item]["discovered"]

func _ready() -> void:
	# Set the img_index to let the inventory_slot know which item to take from the maps
	for item in selection_map:
		selection_map[item].img_index = item

	max_ingredients = selection_map.size()

func _process(_delta: float) -> void:
	for slot in selection_map:
		selection_map[slot].selected = false


	var actions: Array[String] = ["berry_use","nut_use","tofu_use","carrot_use","pepper_use","mint_use"]
	for action in actions:
		if Input.is_action_just_pressed(action):
			select_index = actions.find(action) + 1
			break
	
	if Input.is_action_just_pressed("inventory_left"):
		select_index -= 1
	if Input.is_action_just_pressed("inventory_right"):
		select_index += 1

	if select_index > max_ingredients:
		select_index = 1
	if select_index < 1:
		select_index = max_ingredients
	selection_map[select_index].selected = true
