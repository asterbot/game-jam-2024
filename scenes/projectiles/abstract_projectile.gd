extends RigidBody2D

class_name AbstractProjectile

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func _on_floor_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		body.gravity_scale=1
	queue_free()
	pass
