extends Node


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

var inventory_capacity : int = 40
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
		"inventory_slot": 1,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/berry.tscn")
	},
	"nuts": {
		"inventory_slot": 2,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/nut.tscn")
	},
	"tofus": {
		"inventory_slot": 3,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/tofu.tscn")
	},
	"carrots": {
		"inventory_slot": 4,
		"amount": 0,
		"discovered": false,
		 "scene": preload("res://scenes/ingredients/carrot.tscn")
	},
	"peppers": {
		"inventory_slot": 5,
		"amount": 0,
		"discovered": false,
		"scene": preload("res://scenes/ingredients/pepper.tscn")
	},
	"mints": {
		"inventory_slot": 6,
		"amount": 0,
		"discovered": false,
		 "scene": preload("res://scenes/ingredients/mint.tscn")
	}
}
