extends AbstractEnemy

@export var start_position: Vector2
@export var end_position: Vector2
@export var movement_time: float

@export_enum("fish","cradle") var attack_type: String

# forward = direction from start to end (whatever that means)
var going_forward = true;

func idle(delta):
	# Flip sprites based on direction
	var direction = 1 if going_forward else -1

	# Adjust rotation and flip when necessary
	rotation = ((end_position-start_position)*direction).angle()
	
	var to_flip:bool = rad_to_deg(rotation)<-90 and rad_to_deg(rotation)>-270 
	$Sprite2D.flip_v = to_flip
	$FishProjectile.flip_v = to_flip
	$SoupCradle.flip_v = to_flip
	
	# Calculate velocity based on direction
	velocity = (end_position - start_position)* direction / movement_time
	
	# Move without collision
	position += velocity * delta

	# Toggle direction at boundaries
	if going_forward and position.distance_squared_to(end_position) <= 100:
		going_forward = false
	elif not going_forward and position.distance_squared_to(start_position) <= 100:
		going_forward = true

func hit():
	print("ghost hit")

func attack():
	print("ghost attac")

func _ready() -> void:
	position = start_position
	if start_position.x > end_position.x:
		going_forward = false
	$FishProjectile.visible = (attack_type=="fish")
	$SoupCradle.visible = (attack_type=="cradle")
	super()

func _process(_delta: float) -> void:
	super(_delta)
