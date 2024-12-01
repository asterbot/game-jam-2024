extends AbstractEnemy

@export var start_position: Vector2
@export var end_position: Vector2
@export var movement_time: float

# forward = left to right (always)
var going_forward = (end_position.x - start_position.x) >= 0

# flipped = facing left, not flipped = facing right
var flipped: bool = false;

# Player body node
var player_body: Node2D = null

func toggle_flip(flip: bool):
	$Sprite2D.flip_h = flip
	$FishProjectile.flip_h = flip
	flipped = flip

func idle(delta):
	if not periodic_attack:
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

func hit():
	periodic_attack = false
	$AnimationPlayer.play("dead")

func attack():
	var projectile_scene = preload("res://scenes/projectiles/fish.tscn").instantiate()
	projectile_scene.position = position
	var diff: Vector2 = (player_body.global_position - global_position).normalized()*1000
	projectile_scene.linear_velocity = Vector2(diff.x, diff.y - 500)
	$"../../Projectiles".add_child(projectile_scene)

func _ready() -> void:
	position = start_position
	super()

func _process(_delta: float) -> void:
	if player_body != null:
		periodic_attack = true
		# Unit vector in direction it is facing
		var dir = Vector2(1,0) if not flipped else Vector2(-1,0)
		var result = dir.dot(player_body.global_position-global_position)
		if (result<0):	
			# Reverse the flip
			toggle_flip(not flipped)
	if Globals.tofu_activated:
		periodic_attack = false
	super(_delta)

func _on_attack_area_body_entered(body: Node2D) -> void:
	call_deferred("_handle_attack_area_body_entered", body)

func _handle_attack_area_body_entered(body: Node2D) -> void:
	if not Globals.tofu_activated:
		periodic_attack = true
	player_body = body


func _on_attack_area_body_exited(_body: Node2D) -> void:
	periodic_attack = false
	player_body = null
	$Sprite2D.flip_h = false
	$FishProjectile.flip_h = false
