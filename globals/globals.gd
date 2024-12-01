extends Node

var curr_level = 0

var game_started = false

# I just set this manually, we can use this as the starting position in the game
const DEFAULT_RESPAWN_POS = Vector2(0,0)
var respawn_pos = DEFAULT_RESPAWN_POS

var tofu_activated = false;
var carrot_activated = false;

# if cookbook is open, prevent player from moving
var inventory_unlocked = false
var cookbook_open = false

# for dialogue purposes
var dialogue_triggered = {
	0: false,
	1: false,
	2: false,
	3: false
}

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

var inventory_capacity : int = 30
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
		"amount": 100,
		"discovered": true,
		"scene": preload("res://scenes/ingredients/berry.tscn")
	},
	"nuts": {
		"name": "Nut and Bolt",
		"inventory_slot": 2,
		"amount": 100,
		"discovered": true,
		"scene": preload("res://scenes/ingredients/nut.tscn")
	},
	"tofus": {
		"name": "Tofu Cloak",
		"inventory_slot": 3,
		"amount": 100,
		"discovered": true,
		"scene": preload("res://scenes/ingredients/tofu.tscn")
	},
	"carrots": {
		"name": "Carrot Telescope",
		"inventory_slot": 4,
		"amount": 100,
		"discovered": true,
		 "scene": preload("res://scenes/ingredients/carrot.tscn")
	},
	"peppers": {
		"name": "Pepper Bomb",
		"inventory_slot": 5,
		"amount": 100,
		"discovered": true,
		"scene": preload("res://scenes/ingredients/pepper.tscn")
	},
	"mints": {
		"name": "Mint Saver",
		"inventory_slot": 6,
		"amount": 100,
		"discovered": true,
		"scene": preload("res://scenes/ingredients/mint.tscn")
	}
}

func start_dialogue(state = null):
	"""If state is null, it uses the state saved in globals"""
	dialogue_open = true
	if state != null:
		dialogue_state = state

var dialogue_open = false

# Game states
var dialogue_state = "0_pass"

var dialogues = {
		"0_pass":  {
			"lines" : [ "[oWo] Hello... who are you?",
				  		"[oWo] You... you can see me?",
						"[oWo] You're the first one who has been able to see me since I died 500 years ago",
						"[oWo] It... it is unforgiv-",
						"[??????] WHO AWOKE ME FROM MY SLUMBER???",
						"[??????] AH I SEE, SOMEONE NEW!!!!! HOW EXCITING, I'VE BEEN WAITING FOR SO LONG!!!!!",
						"[??????] I SEE YOU HAVE A CHEF HAT, DOES THAT MEAN YOU CAN COOK????",
						"[oWo] Oh...",
						"[??????] THERE'S A COOKING POT IN FRONT OF YOU, MAKE YOUR WAY THERE AND COOK ME SOME SOUP!",
						"[??????] YOU MAY NOT HAVE WHAT YOU NEED FOR IT YET, YOU SHOULD GO OUT AND FIND SOME THINGS!",
						"[??????] FIND EVERYTHING YOU CAN AND BRING ME BACK THREE OF EACH"
					],
			"completed": false
			},
		"1_pass": {
			"lines" : [ "[??????] AH NOT BAD AT ALL... THIS ISN'T HALF BAD!",
						"[oWo] :3",
						"[??????] I SEE YOUR POTENTIAL NOW AS A TOP SOUP CHEF",
						"[??????] HOWEVER, THESE INGREDIENTS ARE QUTIE BLAND COMPARED TO WHAT I LIKE",
						"[??????] TODAY, I'M CRAVING A LITTLE BIT OF SWEET AND SOUR! A BIT OF SOMETHING CHILLED TOO",
						"[??????] BRING ME 4 OF EACH! OFF YOU GO!!!" 
					],
			"completed": false
			},
		"fail":{
			"lines":[
				"[??????] ............ what is this?",
				"[??????] YOU UNDER-DELIVERED ON YOUR SUPPOSED \"CULINARY SKILLS\"!!!",
				"[??????] TRY AGAIN!"
			],
			"completed": false,
		},
		"2_pass": {
			"lines" : [  "[??????] WELL WELL WELL, YOU HAVE SURPASSED MY EXPECTATIONS ONCE AGAIN!",
						"[??????] I CAN'T BELIEVE YOU FOUND THE MINTS, I TRIED REALLY HARD TO HIDE THEM!",
						"[??????] ALRIGHT, I HAVE ONE LAST REQUEST FOR YOU",
						"[??????] I'D LIKE SOME SPICE IN MY SOUP WITH SOME CRUNCH, IT SHOULD TAKE ME OUT FOR LUNCH! - BRING ME 3 OF EACH",
						"[??????] IT BETTER BE ELECTRIFYING AS WELL, MAKE THE SHOCK DOUBLE THE SPICE!"
						
					],
			"completed": false
			},
		"3_pass": {
			"lines" : [   "[??????] WELL DONE! YOU HAVE IMPRESSED ME BEYOND MY EXPECTATIONS!",
						  "[??????] I RECOGNIZE YOUR TALENT, AND I WANT TO HIRE YOU AS MY FULL-TIME PERSONAL CHEF. HOW DOES THAT SOUND?",
						  "[oWo] psst.... go away ... run away as quick as you can! The mountain giant is very unforgiving!",
						  "[Mountain Giant] NOW, NOW, WE DON'T WANT TO REVEAL OUR SECRETS, DO WE ;)"
					],
			"completed": false
			},
		"1_idle": {
			"lines" : [   
						"[oWo] Remember.... did you bring 3 of everything yet?",
						"[oWo] Feel free to consult the book you found, it looks like it was written by someone important!",
						"[??????] DID SOMEONE SAY SOMETHING?",
						"[oWo] No! Nothing!"
					  ],
			"completed": false
			},
		"2_idle": {
			"lines" : [   
						"[oWo] Remember.... did you bring 4 of everything yet?",
						"[oWo] Should be sweet, sour, and chill",
						"[oWo] The book should lead you where you need to be! Explore and collect!",
						"[??????] WHAAAAAAAT",
						"[oWo] No! Nothing! Sorry to disturb you!"
					  ],
			"completed": false
			},
		"3_idle": {
			"lines" : [   
						"[oWo] I know this particular request is a lot",
						"[oWo] Remember, it must be spicy, crunchy and electrifying",
						"[oWo] But don't fright! For it is but trivial if you look at my travel journa-", 
						"[oWo] Sorry, the book you have on you",
						"[??????] YOU'RE REALLY TESTING MY PATIENCE IN BETWEEN MY NAP!",
						"[oWo] O_O"
					  ],
			"completed": false
			},
		"zero_hat_picked_up": {
			"lines" : ["You unlocked the cookbook! Press W to open"],
			"completed": false
		},
		"ingredient_discovered": {
			"lines" : ["Your cookbook has been updated!"],
			"completed": false
		}
}
