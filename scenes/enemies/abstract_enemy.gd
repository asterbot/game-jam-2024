extends CharacterBody2D

class_name AbstractEnemy

var dead: bool = false;

# If periodic_attack is true, perform attack() peridically regardless
var periodic_attack: bool = false;
var periodic_attack_allowed: bool = true;

func idle(_delta):
	assert(false, "This method must be overriden.")

func hit():
	assert(false, "This method must be overriden.")

func attack():
	assert(false, "This method must be overriden.")

func _ready() -> void:
	$PeriodicTimer.set_wait_time(randf_range(3, 4))

func _process(delta):
	if not dead:
		idle(delta)
		if periodic_attack and periodic_attack_allowed:
			attack()
			periodic_attack_allowed = false;
			$PeriodicTimer.start()

func _on_timer_timeout() -> void:
	periodic_attack_allowed = true
