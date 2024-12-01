extends CanvasLayer


var cur_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.dialogue_open:
		visible = true
		var state = Globals.dialogue_state
		var all_dialogues = Globals.dialogues[state]["lines"]
		var num_dialogues = all_dialogues.size()
		if cur_index == num_dialogues:
			Globals.dialogue_open = false
			visible = false
			cur_index = 0
			Globals.dialogues[state]["completed"] = true
			return
		%RichTextLabel.text = all_dialogues[cur_index]
		if Input.is_action_just_pressed("dialogue_next") and cur_index < num_dialogues:
			cur_index+=1
		
