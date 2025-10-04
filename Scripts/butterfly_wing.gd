extends Sprite2D

var falling = false
var speed = 150.0
var sway_speed = 2.0
var sway_amplitude = 80.0
var time = 0.0
var rotationModifier = 0.2
var swayAmplitudeModifier = 50.0
var speedModifier = 1.0
var sinOffsetX = 0.0
var sinOffsetRotation = 0.0

func _process(delta):
	if falling:
		time += delta
		position.y += speed * delta * speedModifier
		position.x += sin(time * sway_speed + sinOffsetX) * sway_amplitude * swayAmplitudeModifier * delta
		rotation = sin(time * sway_speed + sinOffsetRotation) * rotationModifier  # leichtes Drehen

func fallDown() -> void:
	falling = true
	rotationModifier = randf_range(0.1, 0.3)
	swayAmplitudeModifier = randf_range(0.75, 1.25)
	speedModifier = randf_range(0.8, 1.2)
	sinOffsetX = getSinStartPoint()
	sinOffsetRotation = getSinStartPoint()

func getSinStartPoint() -> float:
	return [0.0, PI].pick_random()
