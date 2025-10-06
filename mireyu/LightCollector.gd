extends AnimationTrigger

class_name LightCollector

@export var allowReset := true

@onready var sprite: Sprite2D = $Sprite2D
var inactiveState: Texture2D = preload("res://Solar01.png")
var activeState: Texture2D = preload("res://Solar02.png")

func onBeamHit() -> void:
	animateTarget()
	sprite.set_texture(activeState)

func onBeamLeave() -> void:
	sprite.set_texture(inactiveState)
	if !reset:
		return
	
	animateTarget(true)
