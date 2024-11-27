extends AbstractEnemy

var player

func idle(_delta):
	pass

func hit():
	dead = true

func attack():
	$AnimationPlayer.play("attack_forward" if not $Sprite2D.flip_h else "attack_backward")
	$AnimationPlayer.queue("idle")

func _ready() -> void:
	periodic_attack = true
	$PeriodicTimer.set_wait_time(randf_range(2, 2))

func _process(delta: float) -> void:
	# if not attacking, find where the player is
	if $AnimationPlayer.current_animation not in ["attack_forward", "attack_backward"] and player != null:
		var forward_direction = global_rotation_degrees
		var direction_to_player = rad_to_deg(global_position.direction_to(player.global_position).angle())
		direction_to_player = (int(direction_to_player - forward_direction) + 720) % 360 # make diretion positive
		if 90 <= direction_to_player and direction_to_player <= 270:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		
	if not dead:
		idle(delta)
		if periodic_attack and periodic_attack_allowed and player != null:
			attack()
			periodic_attack_allowed = false;
			$PeriodicTimer.start()



func _on_player_detection_zone_body_entered(body: Node2D) -> void:
	player = body

func _on_player_detection_zone_body_exited(body: Node2D) -> void:
	player = null
