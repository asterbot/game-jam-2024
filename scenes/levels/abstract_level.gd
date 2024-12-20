extends Node2D

class_name AbstractLevel

signal toggle_cookbook_visibility()

func _ready():
	$Cookbook.visible = true
	$UI.visible = true
	$UI.update_all()
	pass

func _process(_delta):
	if Input.is_action_just_pressed("cookbook") and not Globals.dialogue_open:
		Globals.cookbook_open = not Globals.cookbook_open
		toggle_cookbook_visibility.emit()
