extends CanvasLayer

signal send_selected_item(index:String)

func _on_player_update_ui(items: Dictionary) -> void:
	# Send it to HBoxContainer and let it handle the rest
	%HBoxContainer.receive_data_from_ui(items)
	pass


func _on_player_request_selected_ingredient() -> void:
	send_selected_item.emit(%HBoxContainer.provide_selected_ingredient())
	pass # Replace with function body.
