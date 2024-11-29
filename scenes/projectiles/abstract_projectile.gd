extends RigidBody2D

class_name AbstractProjectile

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if linear_velocity.length() > 0:
		var target_angle = linear_velocity.angle()
		if rad_to_deg(target_angle) > 90 and rad_to_deg(target_angle) < 270:
			$Sprite2D.flip_v = true
		rotation = target_angle

func _on_floor_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		body.gravity_scale=1
	queue_free()
	pass
