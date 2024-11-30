extends CanvasLayer


var pages: Array[Dictionary] = []
var curr_page = 0

func _ready():
	$Cookbook.modulate.a = 0
	pages.append(
		{"left": preload("res://scenes/UI/cookbook/image_page.tscn").instantiate(),
		"right": preload("res://scenes/UI/cookbook/text_page.tscn").instantiate()})
	var page_number = 1
	for ing_name in Globals.ingredients.keys():
		var page_pair = {}
		var left_page = preload("res://scenes/UI/cookbook/image_page.tscn").instantiate()
		var right_page = preload("res://scenes/UI/cookbook/text_page.tscn").instantiate()
		left_page.set_page_number(page_number)
		page_number += 1
		right_page.set_page_number(page_number)
		page_number += 1
		if Globals.ingredients[ing_name]["discovered"]:
			left_page.update_page(Globals.ingredients[ing_name]["inventory_slot"])
			right_page.update_text(Globals.ingredients[ing_name]["inventory_slot"])
		page_pair["left"] = left_page
		page_pair["right"] = right_page
		pages.append(page_pair)
	flip_to_page(curr_page)

func _process(delta):
	# only 
	if Input.is_action_just_pressed("cookbook_left") and Globals.cookbook_open and curr_page > 0:
		curr_page -= 1
		flip_to_page(curr_page)
	if Input.is_action_just_pressed("cookbook_right") and Globals.cookbook_open and curr_page < pages.size()-1:
		curr_page += 1
		flip_to_page(curr_page)

func flip_to_page(page_number):
	# first, remove all nodes from the page containers
	for child in %LeftPage.get_children():
		%LeftPage.remove_child(child)
	for child in %RightPage.get_children():
		%RightPage.remove_child(child)
	# then, add the pages you want back into the containers
	%LeftPage.add_child(pages[page_number]["left"])
	%RightPage.add_child(pages[page_number]["right"])

func make_visible():
	var tween = get_tree().create_tween()
	tween.tween_property($Cookbook, "modulate:a", 1, 0.1)

func make_invisible():
	var tween = get_tree().create_tween()
	tween.tween_property($Cookbook, "modulate:a", 0, 0.1)

func _on_abstract_level_toggle_cookbook_visibility() -> void:
	if Globals.cookbook_open:
		make_visible()
	else:
		make_invisible()


func _on_player_update_ui(ing_name: String) -> void:
	var inventory_index = Globals.ingredients[ing_name]["inventory_slot"]
	var left_page = pages[inventory_index]["left"]
	var right_page = pages[inventory_index]["right"]
	left_page.update_page(Globals.ingredients[ing_name]["inventory_slot"])
	right_page.update_text(Globals.ingredients[ing_name]["inventory_slot"])
