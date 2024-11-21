extends Sprite2D

class_name Plant

@export var amount: int

@export var ingredient_scene: PackedScene

func get_pos(marker):
	return marker.position

func _ready() -> void:
	#given amount, get [amount] positions to add ingredients to
	var spawnPositions = $IngredientPositions.get_children()
	spawnPositions.shuffle()
	for i in range(amount):
		var pos = spawnPositions[i].position
		var ingredient = ingredient_scene.instantiate()
		ingredient.position = pos
		$Ingredients.add_child(ingredient)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
