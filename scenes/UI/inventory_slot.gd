extends PanelContainer

# Selected = has player selected it 
var selected: bool = true;

@export var stylebox_default: StyleBox
@export var stylebox_selected: StyleBox

func set_image(slot: int):
	"""Sets image for the inventory slot to item
	Parameters:
		slot (int) - must be in [0,num_items]
					 0 means default "?" and 1 to num_items for fruits
	"""
	assert (slot>=0 and slot<=Globals.max_index) # just for sanity ig
	%TextureRect.set_texture(Globals.index_sprite_map[slot])

func set_amount(new_qty):
	"""Sets qty of item in UI to new quantity"""
	%Label.text = str(new_qty)

func _ready() -> void:
	# At start, make the qty dash and image default
	set_amount("-")
	set_image(0)

func _process(_delta: float) -> void:
	add_theme_stylebox_override("panel", stylebox_selected if selected else stylebox_default)
