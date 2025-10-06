extends Area2D


@export var next_scene: PackedScene
@export var animator: AnimationPlayer


func _init() -> void:
	connect("body_entered", body_entered)


func body_entered(body: Node2D) -> void:
	if not body is Player: return
	if not next_scene: return
	var player := body as Player
	animator.play("fade_in")
	player.end_level()
	await animator.animation_finished
	get_tree().change_scene_to_packed(next_scene)
