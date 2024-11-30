extends CanvasLayer


var ingredient_descriptions = {
	0:
"""A prospective soup connoisseur
""",
	1:
"""Ah, one of the first delicacies encountered on the adventure! I have craved their tangy sweetness ever since stumbling onto these squishy fruits, so much so that I always make sure to have a few on me at all times.

On top of that, the berries seem to grant mystical powers: although I have stumbled many this treacherous journey, I have always managed to stay on my feet after a berry meal.

It has been quite exciting thus far, and I can only imagine what variety of tastes await further up!

""",
	2:
"""After consuming the berries, imagine my surprise when the next snack I found was nothing like it!

It took me ages to break through the nut's tough exterior, and the insides were just as crunchy. What was most shocking though, was when an undulating tremor coursed through my body as soon as I tasted it.

How electrifying! I was bursting with so much energy that it couldn't stop myself from running for some hours. However strange these foods are, I am being well-fed by nature and I will use these opportunities to continue my journey of becoming a soup master.
""",
	3:
"""Today is the day I first found my first aggressor on this expedition. The little sprout packs a big punch despite looking so tame, so I found some respite in the local ingredients once again.

I didn't think much of the tofu skins on the nearby tree, but the sprout seeds that used to beat me so thoroughly had no ill effect when I grasped them in my hand!


""",
	4:
"""
this is a carrot
""",
	5:
"""
this is a pepper
""",
	6:
"""
this is a mint
"""
}






var pages: Array[Dictionary] = []
var curr_page = 0




func _ready():
	$Cookbook.modulate.a = 0
	var left_page_0 = preload("res://scenes/UI/cookbook/controls.tscn").instantiate()
	var right_page_0 = preload("res://scenes/UI/cookbook/text_page.tscn").instantiate()
	right_page_0.update_text(ingredient_descriptions[0])
	pages.append({"left": left_page_0, "right": right_page_0})
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

func _process(_delta):
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


func _on_player_update_ui(ing_name: String, _using) -> void:
	var inventory_index = Globals.ingredients[ing_name]["inventory_slot"]
	var left_page = pages[inventory_index]["left"]
	var right_page = pages[inventory_index]["right"]
	left_page.update_page(Globals.ingredients[ing_name]["inventory_slot"])
	right_page.update_text(ingredient_descriptions[Globals.ingredients[ing_name]["inventory_slot"]])
