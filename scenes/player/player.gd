extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# directional input
	var direction: Vector2 = Input.get_vector("left","right","up","down")
	velocity = direction * 500
	move_and_slide()
	
	# laser shooting input
	if Input.is_action_pressed("primary action"):
		#print("shoot laser")
		pass
		
	if Input.is_action_pressed("secondary action"):
		#print("shoot grenade")
		pass
