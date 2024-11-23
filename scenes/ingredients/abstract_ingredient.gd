extends RigidBody2D

class_name Ingredient

const SPEED_THRESHOLD: int = 2000
var display_name = ""

func toggle_label(appear: bool):
	"""Toggles label to appear"""
	$Label.visible = appear

func _ready() -> void:
	toggle_label(false)
	$Label.text = display_name

func _process(_delta) -> void:
	if linear_velocity.length_squared() > 0:
		gravity_scale = 1
		if $DespawnTimer.is_stopped():
			$DespawnTimer.start()
	$Label.rotation = -rotation

func _integrate_forces(state) -> void:
	# set upper bound for ingredient velocity
	var velocity = state.get_linear_velocity()
	if velocity.length() > SPEED_THRESHOLD:
		velocity = velocity.normalized() * SPEED_THRESHOLD
	state.set_linear_velocity(velocity)


func _on_despawn_timer_timeout() -> void:
	
	queue_free()
