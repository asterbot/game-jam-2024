extends AbstractEnemy

@export var start_position: Vector2
@export var end_position: Vector2
@export var movement_time: int

@export_enum("fish","cradle") var attack_type: String


var going_forward = true;

func idle():
	$Sprite2D.flip_h = not going_forward
	$FishProjectile.flip_h = not going_forward

	if going_forward:
		velocity = (end_position - start_position)/movement_time
	else:
		velocity = (start_position - end_position)/movement_time
	
	move_and_slide()
	if position.distance_squared_to(end_position) <= 5:
		going_forward = false
	if position.distance_squared_to(start_position) <= 5:
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
	super()


func _process(_delta: float) -> void:
	super(_delta)
