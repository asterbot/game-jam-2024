extends AbstractEnemy

var player = null

func idle(_delta):
	pass

func hit():
	dead = true
	$AnimationPlayer.play("dead")

func attack():
	$AnimationPlayer.play("attack_forward" if not $Sprite2D.flip_h else "attack_backward")
	$AnimationPlayer.queue("idle")

func _ready() -> void:
	periodic_attack = true
	$PeriodicTimer.set_wait_time(3)

func _process(delta: float) -> void:
	# if not attacking, find out where the player is
	if $AnimationPlayer.current_animation not in ["attack_forward", "attack_backward"] and player != null:
		var forward_direction = global_rotation_degrees
		var direction_to_player = rad_to_deg(global_position.direction_to(player.global_position).angle())
		direction_to_player = (int(direction_to_player - forward_direction) + 720) % 360 # make diretion positive
		$Sprite2D.flip_h = (90 <= direction_to_player and direction_to_player <= 270)
		
	super(delta)
	



func _on_player_detection_zone_body_entered(body: Node2D) -> void:
	player = body

func _on_player_detection_zone_body_exited(_body: Node2D) -> void:
	player = null
