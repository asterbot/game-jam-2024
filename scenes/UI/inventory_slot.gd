extends PanelContainer

var enabled:bool = false;

@export var stylebox_default: StyleBox  
@export var stylebox_selected: StyleBox 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	add_theme_stylebox_override("panel",stylebox_selected if enabled else stylebox_default)
	pass
