extends Node2D

class_name AbstractLevel

signal toggle_cookbook_visibility()

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("cookbook"):
		Globals.cookbook_open = not Globals.cookbook_open
		toggle_cookbook_visibility.emit()
