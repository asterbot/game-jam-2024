extends AbstractEnemy

@export var radius: int
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
	rotate_pos = global_position
	periodic_attack = false
	super()

func _process(delta: float) -> void:
	var degrees_per_second = 360/seconds_per_cycle
	var angle_change = degrees_per_second * delta
	if rotate_direction == "CW":
		rotation_degrees -= angle_change
	elif rotate_direction == "CCW":
		rotation_degrees += angle_change
	global_position = rotate_pos + radius * Vector2(sin(rotation), cos(rotation))
	$Sprite2D.rotation = -rotation
	super(delta)
	
	if Input.is_action_just_pressed("berry_select"):
		hit()
