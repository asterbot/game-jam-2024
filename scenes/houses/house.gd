extends Area2D

signal player_entered
signal player_exited

func _on_body_entered(_body: Node2D) -> void:
	player_entered.emit()

func _on_body_exited(_body: Node2D) -> void:
	player_exited.emit()
