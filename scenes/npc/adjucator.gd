extends CharacterBody2D

@export var start_position: Vector2
@export var end_position: Vector2
@export var movement_time: float

@export var talk_position: Vector2

# forward = left to right (always)
var going_forward = (end_position.x - start_position.x) >= 0

# flipped = facing left, not flipped = facing right
var flipped: bool = false;

func _ready() -> void:
	position = start_position

func toggle_flip(flip: bool):
	$Sprite2D.flip_h = flip
	flipped = flip

func _process(delta: float) -> void:
	if not Globals.dialogue_open:
		# Flip sprites based on direction
		var direction = 1 if going_forward else -1

		# Adjust rotation and flip when necessary
		toggle_flip(not going_forward)
		
		# Calculate velocity based on direction
		velocity = (end_position - start_position)* direction / movement_time
		
		# Move without collision
		position += velocity * delta

		# Toggle direction at boundaries
		if going_forward and position.distance_squared_to(end_position) <= 100:
			going_forward = false
		elif not going_forward and position.distance_squared_to(start_position) <= 100:
			going_forward = true
	else:
		var cur_dir = Vector2(1,0) if not flipped else Vector2(-1,0)
		if cur_dir.dot($"../Player".global_position - global_position) < 0:
			toggle_flip(not flipped)
