extends PanelContainer

func set_page_number(num):
	%PageNumber.text = str(num)
	

func update_page(sprite_index):
	%TextureRect.set_texture(Globals.index_sprite_map[sprite_index])
	%Name.text = Globals.ingredients[Globals.index_ingredient_map[sprite_index]]["name"]
