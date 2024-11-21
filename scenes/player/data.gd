extends Node2D

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
		# "scene": preload("res://scenes/ingredients/carrot.tscn")
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
		# "scene": preload("res://scenes/ingredients/mint.tscn")
	}
}
