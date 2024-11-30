extends RigidBody2D

class_name AbstractProjectile

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if linear_velocity.length() > 0:
		var target_angle = linear_velocity.angle()
		target_angle = wrapf(target_angle,0, 2*PI)
		rotation = target_angle

func _on_floor_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		body.gravity_scale=1
	queue_free()
	pass


func _on_despawn_timer_timeout() -> void:
	queue_free()
