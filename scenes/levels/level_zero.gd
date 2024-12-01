extends AbstractLevel

var show_inventory = false

func _ready():
	$UI.visible = false
	%BerryBush/ReplenishTimer.set_wait_time(3)
	%KeyE2.modulate.a = 0
	$Player/PlayerImage.texture = preload("res://assets/player/cat-walk.png")
	if not Globals.game_started:
		$Player.position = Globals.DEFAULT_RESPAWN_POS
		$FrontPage.visible = true
		

func _process(delta):
	if not Globals.game_started and Input.is_action_just_pressed("interact"):
		Globals.game_started = true
		var tween = get_tree().create_tween()
		tween.tween_property($FrontPage/Control, "modulate:a",0,1)

	if show_inventory:
		super(delta)
	else:
		Globals.ingredients["berries"]["amount"] = 0
		Globals.inventory_used = 0

func _on_hat_tree_exited() -> void:
	show_inventory = true
	$UI.visible = true
	Globals.start_dialogue("zero_hat_picked_up")


func _on_berry_zone_body_entered(body: Node2D) -> void:
	if show_inventory:
		var tween = get_tree().create_tween()
		tween.tween_property(%KeyE2, "modulate:a", 1, 1)


func _on_berry_zone_body_exited(body: Node2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%KeyE2, "modulate:a", 0, 1)
