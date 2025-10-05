extends Node2D

var falling = false
var speed = 0.0
var acceleration = 2000.0

func _process(delta):
	if falling:
		speed += acceleration * delta
		position.y += speed * delta

func fallDown() -> void:
	falling = true
	speed = 0.0
