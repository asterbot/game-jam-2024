extends AbstractEnemy

func idle(_delta):
	pass

func hit():
	dead = true
	$AnimationPlayer.play("dead")

func attack():
	$AnimationPlayer.play("attack")
	var seed_scene = preload("res://scenes/projectiles/sprout_seed.tscn")
	for attack_offset in [-15, 0, 15]:
		var seed = seed_scene.instantiate() as RigidBody2D
		var attack_angle = deg_to_rad(attack_offset) + wrapf(global_rotation - PI/2, 0, 2*PI) + randf_range(deg_to_rad(-5), deg_to_rad(5))
		var attack_direction = Vector2(cos(attack_angle), sin(attack_angle))
		seed.position = Vector2(position.x, position.y) + attack_direction*40
		seed.linear_velocity = attack_direction*(860 + sin(attack_angle - PI)*460)
		$"../../Projectiles".add_child(seed)
	$AnimationPlayer.queue("idle")




func _ready() -> void:
	periodic_attack = true
	super()

func _process(_delta: float) -> void:
	super(_delta)
