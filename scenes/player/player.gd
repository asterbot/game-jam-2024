extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

const TOTAL_JUMPS = 5
var jumps : int = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if jumps<TOTAL_JUMPS and not is_on_floor() and Input.is_action_just_pressed("up"):
		velocity.y = JUMP_VELOCITY
		jumps+=1
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps=0

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumps=1

	$Label.text="Jumps: "+str(jumps)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left","right","up","down")
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
