extends Sprite2D

var pos: Vector2 = Vector2.ZERO # same as Vector2(0, 0)
const speed: int = 200
var test_scale: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos = Vector2(300, 200)
	position = pos
	
	#var test_rotation = 45
	#rotation_degrees = test_rotation
	
	test_scale = 2
	scale = Vector2(test_scale, test_scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pos.x += speed * delta
	position = pos
	
	##since test_scale is int, any added number < 1 doesn't change anything
	#test_scale += 1
	#scale = Vector2(test_scale, test_scale)
