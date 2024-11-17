extends HBoxContainer

var select_index = 1;

var max_ingredients = 6

@onready var selection_map = {
	1: $BerrySlot,
	2: $NutSlot,
	3: $TofuSlot,
	4: $CarrotSlot,
	5: $PepperSlot,
	6: $MintSlot
} 

var actions: Array[String] = ["berry_use","nut_use","tofu_use","carrot_use","pepper_use","mint_use"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for slot in selection_map:
		selection_map[slot].enabled = false
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
	selection_map[select_index].enabled = true
