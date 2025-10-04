extends Node2D

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer
func _ready() -> void:
	SceneTransitionAnimation.play("fade_out")
