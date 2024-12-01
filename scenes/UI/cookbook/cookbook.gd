extends CanvasLayer


var ingredient_descriptions = {
	0:
"""Welcome to the writings of a prospective soup connoisseur! In the past, I have heard about a distant mountain that possesses eccentric foods unique to its location, and it has piqued my interest since.

This is the grand culmination of a years-long scavenger hunt, and I am finally at the foot of the mountain today. I will be documenting my journey through this cookbook, listing all the unique foods I can find while I'm here.

To whomever is reading this, I hope you will learn much about my time here!

""",
	1:
"""Ah, one of the first delicacies encountered on the adventure! I have craved their tangy sweetness ever since stumbling onto these squishy fruits, so much so that I always make sure to have a few on me at all times.

On top of that, the berries seem to grant mystical powers: although I have stumbled many times during these treacherous beginnings, I have always managed to stay on my feet after a berry meal.

I have made some good progress thus far. It has been quite exciting, and I can only imagine what variety of tastes await further up!

""",
	2:
"""After consuming the berries, imagine my surprise when the next snack I found was nothing like it!

It took me ages to break through the nut's tough exterior, and the insides were just as difficult to chow on. I wouldn't think to put this in soup, but it wouldn't hurt to experiment. What was most shocking though, was when an undulating tremor coursed through my body as soon as I tasted it.

How electrifying! I was bursting with so much energy that it couldn't stop myself from running for hours. However strange these foods are, I am being well-fed by nature and I will use these opportunities to continue my journey of becoming a soup master.

""",
	3:
"""Today is the day I found my first aggressor on this expedition. The little sprout packs a big punch despite looking so tame, so I found some respite in the local ingredients once again.

I didn't think much of the tofu sheets on the nearby tree, but the sprout seeds that used to beat me so thoroughly had no ill effect when I held them in my hand! The tofu was surprisingly smooth too.

I decided to taste them after I scuttled my way past, but it left a sour taste in my mouth... I could see some enjoying it, but it's not for me.

Meanwhile, I found a small cave nearby to stay for the night. I spotted an ominous pot in the corner, but this might be the safer option considering the dangers outside.

""",
	4:
"""When I woke up the next day, I noticed that the environment seemed a little different: new routes had emerged, new plants had grown, and new enemies threatened to push me deeper into the mountain.

I had become sullen after having seen so many ledges that were just out of my reach, that I could only nibble on my carrots as a measly consolation prize. While the watery, mild flavour didn't blow me away, the slight crunch was a nice touch.

But several platforms appeared in front of my eyes after I finished the whole stick! I've been seeing many ghosts, so I was very happy to use the platforms and leave my current situation behind.

The requests have become more and more difficult, so I hope these hidden paths can help me find just a little more ingredients.

""",
	5:
"""I'm now beginning to regret my choice of scaling the mountain. With the limited options I have to defend myself, I can only run away with the ingredients I have at my disposal.

And so the peppers have been a safe haven. I have been given the power to obliterate any aggressor upon contact, and they've also helped reveal hidden entrances where I can take shelter from the chaos.

During the times I went into hiding, I took interest in the explosive poignancy of these fruits. Their spice levels are unmatched, and the surprisingly spongy texture complements my preferences well. I couldn't resist devouring them.

I know the imminent risks that come from eating my offensive weapons, but what else can I do? It asks for more and more while my resources are growing thin, so I'm doing the best I can.

""",
	6:
"""Mint from the mountain is how I'd expect mint to taste like. Chew on them for a moment, and your mouth will feel chilled in an instant. The roughness of the leaves also gives substance to an otherwise milquetoast ingredient.

Unfortunately, mints also have the uncanny ability to backtrack to your last moments. I have slipped off the mountain several times, but every time I opened my eyes, my feet were firmly planted on the very slopes I fell off.

I've been yearning to return home but it seems impossible nowadays. Every ingredient I collect is not for me. For every stride I take to move forward, it makes no favours and pushes me so far back that I cannot see the progress I have made.

I originally had grand aspirations of becoming a soup chef, but the mountain wants to take those for itself.

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
