extends CharacterBody2D

signal laser(pos, direction)
signal grenade(pos, direction)

var can_laser: bool = true
var can_grenade: bool = true

func _process(_delta):
	# input
	var direction  = Input.get_vector("left", "right", "up", "down")
	var speed = 500
	velocity = direction * speed
	move_and_slide()
	
	# rotate
	look_at(get_global_mouse_position())
	
	
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	# shooting input
	if Input.is_action_pressed("primary action") and can_laser:
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$LaserTimer.start()
		laser.emit(selected_laser.global_position, player_direction)
		$GPUParticles2D.emitting = true
	# grenade input
	if Input.is_action_pressed("secondary action") and can_grenade:
		var grenade_marker = $LaserStartPositions.get_children()[0]
		can_grenade = false
		$GrenadeReloadTimer.start()
		grenade.emit(grenade_marker.global_position, player_direction)
		

func _on_timer_timeout() -> void:
	can_laser = true

func _on_grenade_reload_timer_timeout() -> void:
	can_grenade = true
