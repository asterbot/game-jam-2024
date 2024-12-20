extends Node2D

@export_enum("adjucator", "mountain_giant", "general") var speaker: String

var player_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Key.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_entered and Input.is_action_just_pressed("pick_up"):
		Globals.start_dialogue()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	$Key.visible = true
	player_entered = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	$Key.visible = false
	player_entered = false
