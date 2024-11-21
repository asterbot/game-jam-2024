extends Sprite2D

class_name Plant

@export var amount: int
@export var ingredient_scene: PackedScene


func get_pos(marker):
	return marker.position

func replenish():
	#given amount, get [amount] positions to add ingredients to
	var spawnPositions = $IngredientPositions.get_children()
	spawnPositions.shuffle()
	for i in range(amount):
		var pos = spawnPositions[i].position
		var ingredient = ingredient_scene.instantiate()
		ingredient.position = pos
		$Ingredients.add_child(ingredient)


func _ready() -> void:
	replenish()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Ingredients.get_children().size() == 0 and $ReplenishTimer.is_stopped():
		$ReplenishTimer.start()


func _on_replenish_timer_timeout() -> void:
	replenish()
