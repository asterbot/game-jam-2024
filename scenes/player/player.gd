extends CharacterBody2D

# variables
const H_VEL_DELTA = 20
const MAX_H_VEL = 600
const MAX_V_VEL = 3000
const JUMP_VELOCITY = -860
const EXTRA_JUMP_VELOCITY = -720
const FRICTION = 80

const EXTRA_JUMPS = 10
var extra_jumps_done: int = 0
var direction

@onready var _animation_player = $AnimationPlayer


# signals
signal update_ui(ingredients: Dictionary)
signal request_selected_ingredient()

var ingredients_in_range: Array


func _ready():
	direction = 0
	for raycast in $FloorDetectors.get_children():
		raycast.enabled = true
	$FloorNormalDetector.enabled = true

func near_floor():
	# if 2 of 3 raycast nodes collide with platforms, return True
	var numCollisions = 0
	for raycast in $FloorDetectors.get_children():
		if raycast.is_colliding():
			numCollisions += 1
	return numCollisions >= 2


func get_platform_normal():
	# get platform normal of the tile directly below the player
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
	# out of ingredients in range, return the closest ingredient
	# if there are no ingredients, return null
	var distances = ingredients_in_range.map(get_sq_distance)
	var index = distances.find(distances.min())
	var ingredient = ingredients_in_range[index] if index >= 0 else null
	return ingredient


# runs at the frame rate of the computer (independent from physics frames)
func _process(_delta) -> void:
	# as long as there is movement, animate player with walk cycle
	if velocity.x != 0:
		_animation_player.play("walk")
		_animation_player.advance(0)
	else:
		_animation_player.stop()
	if direction < 0:
		$PlayerImage.flip_h = true
	elif direction > 0:
		$PlayerImage.flip_h = false
	
	#erm debugging
	$Label.text = "Double Jumps Left: " + str(EXTRA_JUMPS - extra_jumps_done)


# runs on every physics frame
func _physics_process(delta: float) -> void:
	# apply gravity each frame, then move immediately
	velocity += get_gravity() * delta
	move_and_slide()
	# mainly for step slopes, velocity is (roughly) set to the slope's direction
	if not near_floor():
		velocity = get_real_velocity()
	# reset jumps
	if is_on_floor():
		extra_jumps_done = 0
	
	# control horizontal movement
	# direction = -1 for left, 1 for right, 0 otherwise
	direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x += direction * H_VEL_DELTA
	# apply friction if no direction or velocity is greater than h_vel threshold
	if direction == 0 or abs(velocity.x) > MAX_H_VEL:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# control vertical movement
	if Input.is_action_just_pressed("up") and (is_on_floor() or near_floor()):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("debug") and extra_jumps_done < EXTRA_JUMPS:
		velocity.y = EXTRA_JUMP_VELOCITY
		extra_jumps_done += 1
	velocity.y = clamp(velocity.y, -MAX_V_VEL, MAX_V_VEL)
	
	# logic for picking up ingredients
	if Input.is_action_just_pressed("pick_up"):
		var pick_up_ingredient = get_closest_ingredient()
		# if there is a closest ingredient, update info in $Data and update UI
		if pick_up_ingredient != null:
			pick_up_ingredient.queue_free()
			var ingredient = pick_up_ingredient.ingredient_name
			$Data.ingredients[ingredient]["discovered"] = true
			$Data.ingredients[ingredient]["amount"] += 1
			update_ui.emit($Data.ingredients)
		
	if Input.is_action_just_pressed("discard"):
		request_selected_ingredient.emit()
		# logic is handled at end of the signal chain

	# for debugging
	if Input.is_action_just_pressed("speed"):
		velocity = 2 * Vector2(-3000, -500)


# code for signals

# update ingredients that are in range of player
func _on_pickup_zone_body_entered(body: Node2D) -> void:
	ingredients_in_range.append(body)
func _on_pickup_zone_body_exited(body: Node2D) -> void:
	ingredients_in_range.erase(body)

# make ingredient fall when player makes contact
func _on_ingredient_detection_zone_body_entered(ingredient: Node2D) -> void:
	ingredient.gravity_scale = 1

func _on_ui_send_selected_item(item: String) -> void:
	# if the player has some of the selected ingredient, remove from data
	if $Data.ingredients[item]["amount"] > 0:
		$Data.ingredients[item]["amount"] -= 1
		update_ui.emit($Data.ingredients)
		var ingredient_scene = $Data.ingredients[item]["scene"].instantiate()
		var offset = 50
		var speed = 300
		# also, throw the ingredient
		ingredient_scene.global_position = global_position + Vector2(-offset if $PlayerImage.flip_h else offset, 0) 
		ingredient_scene.linear_velocity = Vector2(-speed if $PlayerImage.flip_h else speed, 0) + velocity
		$"../Ingredients".add_child(ingredient_scene)
	pass # Replace with function body.
