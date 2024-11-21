extends RigidBody2D


class_name Ingredient

const VERTICAL_THRESHOLD: int = 60000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print("Ing: ",linear_velocity)
	print("Ing: ",linear_velocity.length())
	var normalized = linear_velocity.normalized()
	var len = linear_velocity.length()
	#linear_velocity.y = normalized.y * min(VERTICAL_THRESHOLD, linear_velocity.y)
	linear_velocity.y = clamp(linear_velocity.y, -VERTICAL_THRESHOLD, VERTICAL_THRESHOLD)
