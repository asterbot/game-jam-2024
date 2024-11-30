extends AbstractProjectile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	super(state)
	if rad_to_deg(rotation) > 90 and rad_to_deg(rotation) < 270:
			$Sprite2D.flip_v = true
