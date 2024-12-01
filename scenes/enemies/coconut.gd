extends AbstractEnemy

@export_custom(PROPERTY_HINT_LINK, "suffix:") var radius: Vector2 = Vector2(100, 100)
@export var offset: int = 0
@export var seconds_per_cycle: float = 3
@export_enum("CW", "CCW") var rotate_direction: String

var rotate_pos: Vector2


func idle(_delta):
	pass

func hit():
	dead = true
	$AnimationPlayer.play("dead")

func attack():
	pass

func _ready() -> void:
	rotation_degrees = -offset
	rotate_pos = global_position
	periodic_attack = false
	super()

func _process(delta: float) -> void:
	var degrees_per_second = 360/seconds_per_cycle
	var angle_change = degrees_per_second * delta
	if rotate_direction == "CW":
		rotation_degrees += angle_change
	elif rotate_direction == "CCW":
		rotation_degrees -= angle_change
	global_position = rotate_pos + Vector2(radius.x*cos(rotation), radius.y*sin(rotation))
	$Sprite2D.rotation = -rotation
	super(delta)
