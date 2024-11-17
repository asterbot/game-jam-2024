extends PanelContainer

var enabled:bool = false;

var current_image = 1;

var image_map={
	1: preload("res://assets/ingredients/low_res/berry.png"),
	2: preload("res://assets/ingredients/low_res/nut.png"),
	3: preload("res://assets/ingredients/low_res/berry.png"),
	4: preload("res://assets/ingredients/low_res/berry.png"),
	5: preload("res://assets/ingredients/low_res/berry.png"),
	6: preload("res://assets/ingredients/low_res/berry.png")
}



@export var stylebox_default: StyleBox  
@export var stylebox_selected: StyleBox 

func set_image(current_image):
	%TextureRect.set_texture(image_map[current_image])

func _ready():
	print(current_image)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	add_theme_stylebox_override("panel",stylebox_selected if enabled else stylebox_default)
	pass
