extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.carrot_activated:
		visible = true
		tile_set.set_physics_layer_collision_layer(0,2)
		modulate.a = 0.5
	else:
		visible = false
		tile_set.set_physics_layer_collision_layer(0,0)
