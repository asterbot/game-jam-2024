extends CanvasLayer

var dialogues = {
	"adjucator": {
		"intro": ["Hello I am your adjucator",
				  "Welcome to da cooking competition",
					"You must cook idk man, btw heres a chef hat"],
		"idle": ["Oh youre back? damn"],
	},
	"mountain_giant": {
		"one": ["Hey how are you"],
		"two": ["wassssupp"],
	},
	"general": {
		"zero_hat_picked_up": ["You unlocked the cookbook!"],
		"ingredient_discovered": ["Your cookbook has been updated!"]
	}
}

var cur_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.dialogue_open:
		visible = true
		var speaker = Globals.dialogue_speaker
		var state = Globals.dialogue_states[speaker]
		var all_dialogues = dialogues[speaker][state]
		var num_dialogues = all_dialogues.size()
		if cur_index == num_dialogues:
			Globals.dialogue_open = false
			Globals.dialogue_speaker = null
			visible = false
			cur_index = 0
			return
		%RichTextLabel.text = all_dialogues[cur_index]
		if Input.is_action_just_pressed("dialogue_next") and cur_index < num_dialogues:
			cur_index+=1
		
