extends CharacterBody2D

func _process(delta):
	var direction = Vector2.RIGHT # same as (1, 0)
	var speed = 100
	velocity = direction * speed
	
	move_and_slide()
