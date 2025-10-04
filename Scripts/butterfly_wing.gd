extends Sprite2D

var falling = false
var speed = 150.0
var sway_speed = 2.0
var sway_amplitude = 80.0
var time = 0.0

func _process(delta):
	if falling:
		time += delta
		position.y += speed * delta
		position.x += sin(time * sway_speed) * sway_amplitude * delta
		rotation = sin(time * sway_speed) * 0.2  # leichtes Drehen

func fallDown() -> void:
	falling = true
