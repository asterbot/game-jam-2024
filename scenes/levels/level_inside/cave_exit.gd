extends Area2D

var can_leave = false

func _ready():
	$Key/Sprite2D.set_texture(preload("res://assets/keys/letters/q_key.png"))
	$Key.visible = false

func _process(_delta):
	if can_leave and Input.is_action_just_pressed("interact") and not Globals.cookbook_open and not Globals.dialogue_open:
		Transition.change_scene("res://scenes/levels/level_debug.tscn")

func _on_body_entered(body: Node2D) -> void:
	can_leave = true
	$Key.visible = true

func _on_body_exited(body: Node2D) -> void:
	can_leave = false
	$Key.visible = false
