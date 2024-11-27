extends AbstractEnemy

@export var start_position: Vector2
@export var end_position: Vector2
@export var movement_time: float

@export_enum("fish","cradle") var attack_type: String

# forward = direction from start to end (whatever that means)
var going_forward = true;

# Player body node
var player_body: Node2D

func idle(delta):
	if not periodic_attack:
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
	if attack_type == "fish":
		var projectile_scene = preload("res://scenes/projectiles/fish.tscn").instantiate()
		projectile_scene.position = position
		projectile_scene.linear_velocity = (player_body.global_position - global_position).normalized()*2000
		$"../../Projectiles".add_child(projectile_scene)

func _ready() -> void:
	position = start_position
	$FishProjectile.visible = (attack_type=="fish")
	$SoupCradle.visible = (attack_type=="cradle")
	super()

func _process(_delta: float) -> void:
	super(_delta)

func _on_attack_area_body_entered(body: Node2D) -> void:
	call_deferred("_handle_attack_area_body_entered", body)

func _handle_attack_area_body_entered(body: Node2D) -> void:
	periodic_attack = true
	player_body = body

func _on_attack_area_body_exited(_body: Node2D) -> void:
	periodic_attack = false
