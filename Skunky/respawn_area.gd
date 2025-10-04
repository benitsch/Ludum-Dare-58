extends Area2D


func _init() -> void:
	connect("body_entered", body_entered)


func body_entered(body: Node2D) -> void:
	if body is Player:
		body.respawn_pos = global_position;
