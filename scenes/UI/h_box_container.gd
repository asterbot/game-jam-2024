extends HBoxContainer

var selected = 1;

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
		if Input.is_action_pressed(action):
			selected = actions.find(action) + 1
			break
	selection_map[selected].enabled = true
	pass
