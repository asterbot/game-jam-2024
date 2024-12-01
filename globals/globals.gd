extends Node

var curr_level = 0

# I just set this manually, we can use this as the starting position in the game
const DEFAULT_RESPAWN_POS = Vector2(4248, -3256)
var respawn_pos = DEFAULT_RESPAWN_POS

var tofu_activated = false;
var carrot_activated = false;

# if cookbook is open, prevent player from moving
var inventory_unlocked = false
var cookbook_open = false


# index value -> sprite for fruit at index
const index_sprite_map={
	0: preload("res://assets/ingredients/low_res/unrevealed.png"),
	1: preload("res://assets/ingredients/low_res/berry.png"),
	2: preload("res://assets/ingredients/low_res/nut.png"),
	3: preload("res://assets/ingredients/low_res/tofu.png"),
	4: preload("res://assets/ingredients/low_res/carrot.png"),
	5: preload("res://assets/ingredients/low_res/pepper.png"),
	6: preload("res://assets/ingredients/low_res/mint.png")
}

# Max index in the hotbar 
var max_index = index_sprite_map.size() - 1

var inventory_capacity : int = 1
var inventory_used: int = 0

# inventory slot -> item name
const index_ingredient_map = {
	1: "berries",
	2: "nuts",
	3: "tofus",
	4: "carrots",
	5: "peppers",
	6: "mints"
}

# The index currently selected in the inventory
var selected_index_ui = 1;

# store info about player in JSON-like format
# information here is updated onto the UI via signals
var ingredients = {
	"berries": {
		"name": "Winged Berry",
		"inventory_slot": 1,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/berry.tscn")
	},
	"nuts": {
		"name": "Nut and Bolt",
		"inventory_slot": 2,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/nut.tscn")
	},
	"tofus": {
		"name": "Tofu Cloak",
		"inventory_slot": 3,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/tofu.tscn")
	},
	"carrots": {
		"name": "Carrot Telescope",
		"inventory_slot": 4,
		"amount": 0,
		"discovered": false,
		 "scene": preload("res://scenes/ingredients/carrot.tscn")
	},
	"peppers": {
		"name": "Pepper Bomb",
		"inventory_slot": 5,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/pepper.tscn")
	},
	"mints": {
		"name": "Mint Saver",
		"inventory_slot": 6,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/mint.tscn")
	}
}

func start_dialogue(speaker: String, state = null):
	"""If state is null, it uses the state saved in globals"""
	dialogue_speaker = speaker
	if state!=null:
		dialogue_states[dialogue_speaker] = state
	dialogue_open = true

var dialogue_open = false

var dialogue_speaker = null

# Game states
var dialogue_states = {
	"adjucator": "intro",
	"mountain_giant": "one",
	"general": "default"
}
