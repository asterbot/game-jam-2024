extends CanvasLayer

func _ready():
	$ColorRect.modulate = Color(1, 1, 1, 0)

func change_scene(target_scene: String):
	Globals.cookbook_open = true
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file.call_deferred(target_scene)
	$AnimationPlayer.play_backwards("fade_out")
	await $AnimationPlayer.animation_finished
	Globals.cookbook_open = false
