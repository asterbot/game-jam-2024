extends Area2D

var player_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EKey.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_entered and Input.is_action_just_pressed("pick_up"):
		print("dialogue started")


func _on_body_entered(body: Node2D) -> void:
	print("dialogue!")
	$EKey.visible = true
	player_entered = true


func _on_body_exited(body: Node2D) -> void:
	$EKey.visible = false
	player_entered = false
