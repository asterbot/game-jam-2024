extends RigidBody2D

var entities_in_explosion_zone = []

func explode():
	$Pepper.visible = false
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation_degrees = 0
	freeze = true
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("explode")
	for entity in entities_in_explosion_zone:
		if entity.is_in_group("player"):
			add_to_group("projectiles")
			entity.item_detection(self)
		else:
			entity.hit()

func _on_explosion_trigger_body_entered(_body: Node2D) -> void:
	$DespawnTimer.stop()
	call_deferred("explode")

func _on_explosion_zone_body_entered(body: Node2D) -> void:
	entities_in_explosion_zone.append(body)


func _on_explosion_zone_body_exited(body: Node2D) -> void:
	entities_in_explosion_zone.erase(body)

func _on_despawn_timer_timeout() -> void:
	explode()
