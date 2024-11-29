extends AbstractEnemy

func idle(_delta):
	pass

func hit():
	dead = true
	$AnimationPlayer.play("dead")

func attack():
	$AnimationPlayer.play("attack")
	var projectile_scene = preload("res://scenes/projectiles/sprout_seed.tscn").instantiate()
	projectile_scene.position = Vector2(position.x, position.y - 50)
	var target_angle = wrapf(rotation-PI/2,-PI, PI) + randf_range(deg_to_rad(-20),deg_to_rad(20))
	projectile_scene.linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * 750
	$"../../Projectiles".add_child(projectile_scene)
	$AnimationPlayer.queue("idle")

func _ready() -> void:
	periodic_attack = true
	super()

func _process(_delta: float) -> void:
	super(_delta)
