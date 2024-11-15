extends CharacterBody2D


const H_VEL_DELTA = 25
const MAX_H_VEL = 600.0
const MAX_V_VEL = 4000.0
const JUMP_VELOCITY = -800.0
const EXTRA_JUMP_VELOCITY = -600.0
const FRICTION = 80

const EXTRA_JUMPS = 10
var extra_jumps : int = 0


func _ready():
	for raycast in $FloorDetectors.get_children():
		raycast.enabled = true
	$Test.enabled = true

func near_floor():
	var numCollisions = 0
	for raycast in $FloorDetectors.get_children():
		if raycast.is_colliding():
			numCollisions += 1
	return numCollisions >= 2


func get_platform_normal():
	var raycast = $Test
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMapLayer:
			var floor_normal = raycast.get_collision_normal()
			return floor_normal
	return Vector2.ZERO


func _physics_process(delta: float) -> void:
	
	# apply gravity each frame, apply move immediately
	velocity += get_gravity() * delta
	move_and_slide()
	
	if not near_floor():
		velocity = get_real_velocity()
	
	# reset jumps
	if is_on_floor():
		extra_jumps = 0
	
	# control horizontal movement
	# direction = -1 for left, 1 for right
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x += direction * H_VEL_DELTA
	if direction == 0 or velocity.x < -MAX_H_VEL or velocity.x > MAX_H_VEL:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	$PlayerImage.flip_h = (direction<0)
	

	# control vertical movement
	if Input.is_action_just_pressed("up") and (is_on_floor() or near_floor()):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("debug") and extra_jumps < EXTRA_JUMPS:
		velocity.y = EXTRA_JUMP_VELOCITY
		extra_jumps += 1
	
	$Label.text = "Double Jumps Left: " + str(EXTRA_JUMPS - extra_jumps)
	
	if Input.is_action_just_pressed("speed"):
		velocity = 2*Vector2(-3000, -500)
	
	#print(velocity)
