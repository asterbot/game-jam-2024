extends AbstractEnemy

func idle():
	$AnimationPlayer.queue("idle")

func hit():
	dead = true
	$AnimationPlayer.play("dead")

func attack():
	$AnimationPlayer.play("attack")
	$AnimationPlayer.queue("idle")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	periodic_attack = true
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super(_delta)
