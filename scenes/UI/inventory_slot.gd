extends PanelContainer

# Selected = has player selected it 
var selected: bool = true;

# Discovered = has player found it yet 
var discovered : bool = false;

# Updates as we receive signals from player
var qty: String = '-';

# Set by hbox class
var img_index : int = 0;

var image_map={
	0: preload("res://assets/ingredients/low_res/unrevealed.png"),
	1: preload("res://assets/ingredients/low_res/berry.png"),
	2: preload("res://assets/ingredients/low_res/nut.png"),
	3: preload("res://assets/ingredients/low_res/berry.png"),
	4: preload("res://assets/ingredients/low_res/carrot.png"),
	5: preload("res://assets/ingredients/low_res/berry.png"),
	6: preload("res://assets/ingredients/low_res/mint.png")
}

var num_items : int = image_map.size() - 1

@export var stylebox_default: StyleBox  
@export var stylebox_selected: StyleBox 

func set_image(slot: int):
	"""Sets image for the inventory slot to item
	Parameters:
		slot (int) - must be in [0,num_items]
					 0 means default "?" and 1 to num_items for fruits
	"""
	assert (slot>=0 and slot<=num_items) # just for sanity ig
	%TextureRect.set_texture(image_map[slot])

func set_qty(new_qty):
	"""Sets qty of item in UI to new quantity"""
	qty = str(new_qty)
	%Label.text = str(qty)

func _process(_delta: float) -> void:
	add_theme_stylebox_override("panel", stylebox_selected if selected else stylebox_default)
	set_image(img_index if discovered else 0)
	set_qty("-" if not discovered else qty)
