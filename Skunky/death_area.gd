extends Area2D


@export var kill_directional: bool = false


func _init() -> void:
	connect("body_entered", body_entered)


func body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		if not kill_directional or global_transform.y.dot(player.velocity) > 0:
			player.kill();
