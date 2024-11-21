extends Sprite2D

class_name Plant

@export var amount: int

@export var ingredient_scene: PackedScene

func _ready() -> void:
	var spawnPositions = $IngredientPositions.get_children()
	spawnPositions.shuffle()
	for i in range(amount):
		var pos = spawnPositions[i].position
		var ingredient = ingredient_scene.instantiate()
		ingredient.position = pos
		
		$Ingredients.add_child(ingredient)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
