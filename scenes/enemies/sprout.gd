extends AbstractEnemy

func idle(_delta):
	pass

func hit():
	dead = true
	$AnimationPlayer.play("dead")

func attack():
	$AnimationPlayer.play("attack")
	$AnimationPlayer.queue("idle")

func _ready() -> void:
	periodic_attack = true
	super()

func _process(_delta: float) -> void:
	super(_delta)
