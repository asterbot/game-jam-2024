extends CanvasLayer

signal send_selected_item(index:String, purpose: String)

func _ready()->void:
	%HBoxContainerTofu.visible = false
	%HBoxContainerCarrot.visible = false
	
func _process(_delta)->void:
	if Globals.tofu_activated:
		%HBoxContainerTofu.modulate = Color(1,1,1,1)
		%ProgressBarTofu.value = (%TimerTofu.time_left)*100/(%TimerTofu.wait_time)
	else:
		%HBoxContainerTofu.modulate = Color(0.5,0.5,0.5,0.4)

	if Globals.carrot_activated:
		%HBoxContainerCarrot.modulate = Color(1,1,1,1)
		%ProgressBarCarrot.value = (%TimerCarrot.time_left)*100/(%TimerCarrot.wait_time)
	else:
		%HBoxContainerCarrot.modulate = Color(0.5,0.5,0.5,0.4)
		
func _on_player_update_ui(ingredient: String, using: bool) -> void:
	# Send it to HBoxContainer and let it handle the rest
	%HBoxContainer.receive_data_from_ui(ingredient)
	if using and ingredient == "tofus":
		%HBoxContainerTofu.visible = true
		%TimerTofu.start()
		Globals.tofu_activated = true
	if using and ingredient == "carrots":
		%HBoxContainerCarrot.visible = true
		%TimerCarrot.start()
		Globals.carrot_activated = true


func _on_player_request_selected_ingredient(purpose: String) -> void:
	send_selected_item.emit(%HBoxContainer.provide_selected_ingredient(), purpose)

func update_all():
	for ingredient_name in Globals.ingredients.keys():
		%HBoxContainer.receive_data_from_ui(ingredient_name)


func _on_timer_tofu_timeout() -> void:
	# Reset
	Globals.tofu_activated = false


func _on_timer_carrot_timeout() -> void:
	# Reset
	Globals.carrot_activated = false
