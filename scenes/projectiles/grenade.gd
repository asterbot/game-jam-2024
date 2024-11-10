extends RigidBody2D

const speed = 750

func explode() -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation_degrees = 0
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explosion")
