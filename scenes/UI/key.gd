extends Node2D

@export var sprite_image: Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = sprite_image
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
