extends Node2D


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var berries = $Bush/Ingredients.get_children()
	for b in berries:
		print(b.position)
		print(b.global_position)
	print($Player.global_position)
	print()
