extends Node2D

var test_array: Array[String] = ["hello", "bye", "perry the platypus"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# targets the Logo node with $Logo to modify it
	$Logo.rotation_degrees = 90
	

	print(test_array[0])	
	for s in test_array:
		print(s)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Logo.rotation_degrees += 60 * delta
	
	if ($Logo.position.x > 1000):
		$Logo.pos.x = 0
		# note: pos, NOT position
		# in logo.gd, we update the position attribute with pos
