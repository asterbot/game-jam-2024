extends LevelParent

func _on_gate_player_entered_gate(_body) -> void:
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.18)
	get_tree().change_scene_to_file.call_deferred("res://scenes/levels/inside.tscn")
