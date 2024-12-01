extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		body.queue_free()
	else:
		body.hit()
		body.global_position = Globals.respawn_pos
		body.velocity = Vector2.ZERO
