extends Area2D

var speed: int = 1000
var direction: Vector2 = Vector2.UP # for now, just fire upwards

func _process(delta) -> void:
	position += direction * speed * delta
