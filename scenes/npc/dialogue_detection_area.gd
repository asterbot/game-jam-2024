extends Node2D

@export_enum("adjucator", "mountain_giant", "general") var speaker: String

var player_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EKey.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_entered and Input.is_action_just_pressed("pick_up"):
		Globals.dialogue_speaker = speaker
		Globals.dialogue_open = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	$EKey.visible = true
	player_entered = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	$EKey.visible = false
	player_entered = false
