extends CanvasLayer

signal send_selected_item(index:String, purpose: String)

func _on_player_update_ui(ingredient: String) -> void:
	# Send it to HBoxContainer and let it handle the rest
	%HBoxContainer.receive_data_from_ui(ingredient)


func _on_player_request_selected_ingredient(purpose: String) -> void:
	send_selected_item.emit(%HBoxContainer.provide_selected_ingredient(), purpose)

func update_all():
	print("hi")
	for ingredient_name in Globals.ingredients.keys():
		%HBoxContainer.receive_data_from_ui(ingredient_name)
