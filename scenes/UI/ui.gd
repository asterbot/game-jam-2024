extends CanvasLayer


func _on_player_update_ui(items: Dictionary) -> void:
	# Send it to HBoxContainer and let it handle the rest
	%HBoxContainer.receive_data_from_ui(items)
	pass
