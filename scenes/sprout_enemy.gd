extends StaticBody2D

var can_attack = true
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AttackTimer.set_wait_time(randf_range(3, 4))


func hit():
	dead = true
	$AnimationPlayer.play("dead")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not dead:
		if can_attack:
			$AnimationPlayer.play("attack")
			$AnimationPlayer.queue("idle")
			can_attack = false
			$AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	can_attack = true
