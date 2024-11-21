extends CharacterBody2D

const H_VEL_DELTA = 20
const MAX_H_VEL = 600.0
const MAX_V_VEL = 4000.0
const JUMP_VELOCITY = -860.0
const EXTRA_JUMP_VELOCITY = -720.0
const FRICTION = 80

const EXTRA_JUMPS = 10
var extra_jumps_done : int = 0

@onready var _animation_player = $AnimationPlayer

signal update_ui(ingredients:Dictionary)

var ingredients_in_range: Array

func _ready():
	for raycast in $FloorDetectors.get_children():
		raycast.enabled = true
	$FloorNormalDetector.enabled = true

func near_floor():
	var numCollisions = 0
	for raycast in $FloorDetectors.get_children():
		if raycast.is_colliding():
			numCollisions += 1
	return numCollisions >= 2


func get_platform_normal():
	var raycast = $FloorNormalDetector
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMapLayer:
			var floor_normal = raycast.get_collision_normal()
			return floor_normal
	return Vector2.ZERO

func get_sq_distance(ingredient):
	return position.distance_squared_to(ingredient.global_position)	

func get_closest_ingredient():
	var distances = ingredients_in_range.map(get_sq_distance)
	var index = distances.find(distances.min())
	
	var ingredient = ingredients_in_range[index] if index>=0 else null
	return ingredient

func _physics_process(delta: float) -> void:
	
	# apply gravity each frame, apply move immediately
	velocity += get_gravity() * delta
	move_and_slide()
	
	if not near_floor():
		velocity = get_real_velocity()
	
	# reset jumps
	if is_on_floor():
		extra_jumps_done = 0
	
	# control horizontal movement
	# direction = -1 for left, 1 for right
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x += direction * H_VEL_DELTA

	if direction == 0 or velocity.x < -MAX_H_VEL or velocity.x > MAX_H_VEL:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
			
	# Check velocity instead of input direction so that it's animated as long as there is movement
	if velocity.x != 0:
		_animation_player.play("walk")
		_animation_player.advance(0)
	else:
		_animation_player.stop()
	
	if direction < 0:
		$PlayerImage.flip_h = true
	elif direction > 0:
		$PlayerImage.flip_h = false
	
	# control vertical movement
	if Input.is_action_just_pressed("up") and (is_on_floor() or near_floor()):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("debug") and extra_jumps_done < EXTRA_JUMPS:
		velocity.y = EXTRA_JUMP_VELOCITY
		extra_jumps_done += 1
	
	$Label.text = "Double Jumps Left: " + str(EXTRA_JUMPS - extra_jumps_done)
	
	if Input.is_action_just_pressed("speed"):
		velocity = 2 * Vector2(-3000, -500)
	
	
	if Input.is_action_just_pressed("pick_up"):
		var pick_up_ingredient = get_closest_ingredient()
		if pick_up_ingredient != null:
			pick_up_ingredient.queue_free()
			var ingredient = pick_up_ingredient.ingredient_name
			if not $Data.ingredients[ingredient]["discovered"]:
				$Data.ingredients[ingredient]["discovered"] = true
			$Data.ingredients[ingredient]["amount"] += 1
			update_ui.emit($Data.ingredients)
		
	#print(velocity)
	


func _on_pickup_zone_body_entered(body: Node2D) -> void:
	ingredients_in_range.append(body)



func _on_pickup_zone_body_exited(body: Node2D) -> void:
	ingredients_in_range.erase(body)
