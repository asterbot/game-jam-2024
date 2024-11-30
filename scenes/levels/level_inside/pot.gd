extends Area2D

signal ingredient_collected(ingredient_type)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_body_entered(ingredient: Node2D) -> void:
	emit_signal("ingredient_collected", ingredient.ingredient_name)
	ingredient.queue_free()