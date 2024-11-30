extends CharacterBody2D

# variables
const H_VEL_DELTA = 20
const MAX_H_VEL = 600
const MAX_V_VEL = 3000

# dash velocity when using nut
const NUT_X_VEL = 1850
const NUT_Y_VEL = -250
# jump velocity when using berries
const BERRY_Y_VEL = -930

# regular jump velocity
const JUMP_VELOCITY = -860
const FRICTION = 80

const DEATH_HEIGHT = 5000

var extra_jumps_done: int = 0
var direction = 0

var is_vulnerable = true;

@onready var player_animation = $PlayerAnimation
@onready var vfx_animation = $Vfx/VfxAnimation

# signals
signal update_ui(ingredient: String)
signal request_selected_ingredient(purpose: String) 
# purpose = what action we want to request the selected item for

var ingredients_in_range: Array


func _ready():
	for raycast in $FloorDetectors.get_children():
		raycast.enabled = true
	$FloorNormalDetector.enabled = true
	$Vfx/BerryEffect.visible = false
	$Vfx/NutEffect.visible = false

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

func get_closest_ingredient():
	# out of ingredients in range, return the closest ingredient
	# if there are no ingredients, return null
	
	# Toggle all the labels of ingredients to false (make them invisible)
	for ingredient in ingredients_in_range:
		ingredient.toggle_label(false);
		
	# Find closest
	var distances = ingredients_in_range.map(func(item): return position.distance_squared_to(item.global_position))
	var index = distances.find(distances.min())
	var ingredient = ingredients_in_range[index] if index >= 0 else null
	
	# If we have an ingredient in closest, make label visible
	if ingredient != null:
		ingredient.toggle_label(true)
	return ingredient


# runs at the frame rate of the computer (independent from physics frames)
func _process(_delta) -> void:
	# as long as there is movement, animate player with walk cycle
	if velocity.x != 0:
		player_animation.play("walk")
		player_animation.advance(0)
	else:
		player_animation.stop()
	if direction < 0:
		$PlayerImage.flip_h = true
		$Vfx/BerryEffect.flip_h = true
		$Vfx/BerryEffect.position.x = 20
	elif direction > 0:
		$PlayerImage.flip_h = false
		$Vfx/BerryEffect.flip_h = false
		$Vfx/BerryEffect.position.x = -10
	
	if not vfx_animation.is_playing(): # if not playing, set direction of vfx
		if direction < 0:
			$Vfx/NutEffect.flip_h = true
			$Vfx/NutEffect.position.x = 140
		elif direction > 0:
			$Vfx/NutEffect.flip_h = false
			$Vfx/NutEffect.position.x = -140


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

	if position.y >= DEATH_HEIGHT:
		velocity = Vector2.ZERO
		position = Globals.respawn_pos
	
	# control horizontal movement
	# direction = -1 for left, 1 for right, 0 otherwise
	direction = Input.get_axis("left", "right")
	if direction != 0 and not Globals.cookbook_open:
		velocity.x += direction * H_VEL_DELTA
	# apply friction if no direction or velocity is greater than h_vel threshold
	if direction == 0 or abs(velocity.x) > MAX_H_VEL:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# control vertical movement
	if Input.is_action_just_pressed("up") and (is_on_floor() or near_floor()) and not Globals.cookbook_open:
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("debug"):
		velocity.y = -1500
		extra_jumps_done += 1
	velocity.y = clamp(velocity.y, -MAX_V_VEL, MAX_V_VEL)
	
	# logic for picking up ingredients
	var pick_up_ingredient = get_closest_ingredient()
	# if there is a closest ingredient, update info in $Data and update UI
	if pick_up_ingredient != null and Input.is_action_just_pressed("pick_up") and not Globals.cookbook_open:
		if pick_up_ingredient.ingredient_name!="hat" and Globals.inventory_used < Globals.inventory_capacity:
			pick_up_ingredient.queue_free()
			var ingredient_name = pick_up_ingredient.ingredient_name
			Globals.ingredients[ingredient_name]["discovered"] = true
			Globals.ingredients[ingredient_name]["amount"] += 1
			Globals.inventory_used += 1
			update_ui.emit(ingredient_name)
		elif pick_up_ingredient.ingredient_name=="hat":
			pick_up_ingredient.queue_free()
			$PlayerImage.texture = preload("res://assets/player/cat-walk-hat.png")
		
	# These are the actions where we need to request the selected ingredient from the UI
	var request_actions = ["discard", "use_item"]
	for action in request_actions:
		if Input.is_action_just_pressed(action) and not Globals.cookbook_open:
			request_selected_ingredient.emit(action)
	 		# logic is handled at end of the signal chain
			break

	# for debugging
	if Input.is_action_just_pressed("speed"):
		velocity = 2 * Vector2((-3000 if $PlayerImage.flip_h else 3000), -500)


# ----------------------------------------code for signals--------------------------------------------------------

# update ingredients that are in range of player
func _on_pickup_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		ingredients_in_range.append(body)
	

func _on_pickup_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		body.toggle_label(false);
		ingredients_in_range.erase(body)

# make ingredient fall when player makes contact
func _on_ingredient_detection_zone_body_entered(body: Node2D) -> void:
	call_deferred("item_detection", body)

func item_detection(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		body.gravity_scale = 1
	if is_vulnerable and (body.is_in_group("projectiles") or body.is_in_group("enemies")):
		$InvulnerableTimer.start()
		$PlayerImage.material.set_shader_parameter("progress",0.3)
		is_vulnerable = false;

		var dir = (global_position - body.global_position).normalized()
		velocity = dir * 600

		var all_ingredients = []
		for ingredient in Globals.ingredients:
			for i in range(Globals.ingredients[ingredient]["amount"]):
				all_ingredients.append(ingredient)
		
		all_ingredients.shuffle()
		for item in range(min(all_ingredients.size(), randi()%3 + 1)):
			Globals.ingredients[all_ingredients[item]]["amount"] -= 1
			Globals.inventory_used -= 1
			update_ui.emit(all_ingredients[item])
			var ingredient_scene = Globals.ingredients[all_ingredients[item]]["scene"].instantiate()
			var offset_x = 30
			var offset_y = 30
			var speed = 350
			# also, throw the ingredient
			ingredient_scene.global_position = global_position + Vector2(-offset_x if $PlayerImage.flip_h else offset_x, -offset_y) 
			ingredient_scene.linear_velocity = Vector2(-speed if $PlayerImage.flip_h else speed, 0) + velocity
			$"../Ingredients".add_child(ingredient_scene)


func _on_ui_send_selected_item(item: String, purpose: String) -> void:
	# if the player has some of the selected ingredient, remove from data
	if purpose=="discard":
		if Globals.ingredients[item]["amount"] > 0:
			Globals.ingredients[item]["amount"] -= 1
			Globals.inventory_used -= 1
			update_ui.emit(item)
			var ingredient_scene = Globals.ingredients[item]["scene"].instantiate()
			var offset_x = 30
			var offset_y = 30
			var speed = 350
			# also, throw the ingredient
			ingredient_scene.global_position = global_position + Vector2(-offset_x if $PlayerImage.flip_h else offset_x, -offset_y) 
			ingredient_scene.linear_velocity = Vector2(-speed if $PlayerImage.flip_h else speed, 0) + velocity
			$"../Ingredients".add_child(ingredient_scene)
	elif purpose=="use_item":
		if Globals.ingredients[item]["amount"] > 0:
			# Handle all the cases here
			match item:
				"berries":
					print("used berries!")
					velocity.y = BERRY_Y_VEL
					vfx_animation.stop()
					$Vfx/NutEffect.visible = false
					vfx_animation.play("berry_vfx")
				"nuts":
					print("used nuts!")
					velocity.x += -NUT_X_VEL if $PlayerImage.flip_h else NUT_X_VEL
					if abs(velocity.x) < NUT_X_VEL:
						velocity.x = -NUT_X_VEL if $PlayerImage.flip_h else NUT_X_VEL
					velocity.y += NUT_Y_VEL
					vfx_animation.stop()
					$Vfx/BerryEffect.visible = false
					vfx_animation.play("nut_vfx")
				"tofus":
					print("used tofus!")
				"carrots":
					print("used carrots!")
				"peppers":
					print("used peppers!")
				"mints":
					print("used mints!")
					# get_platform_normal return zero vector if there is no intersection with ground and middle raycast
					if not(is_on_floor() and get_platform_normal() != Vector2.ZERO): return
					var checkpoint_scene = preload("res://scenes/ingredients/mint_flag.tscn").instantiate()
					checkpoint_scene.global_position = global_position
					Globals.respawn_pos = checkpoint_scene.global_position # set the last checkpoint to respawn to
					#checkpoint_scene.rotation = 0
					for child in $"../Checkpoints".get_children():
						child.queue_free()
					$"../Checkpoints".add_child(checkpoint_scene)

			# Decrement amount and update_ui
			Globals.ingredients[item]["amount"] -= 1
			Globals.inventory_used -= 1
			update_ui.emit(item)


func _on_invulnerable_timer_timeout() -> void:
	$PlayerImage.material.set_shader_parameter("progress",0)
	is_vulnerable = true
