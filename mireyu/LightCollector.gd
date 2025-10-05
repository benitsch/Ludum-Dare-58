extends AnimationTrigger

class_name LightCollector

@onready var sprite: Sprite2D = $Sprite2D
var inactiveState: Texture2D = preload("res://Solar01.png")
var activeState: Texture2D = preload("res://Solar02.png")


func _init() -> void:
	onlyTriggerOnce = true

func onBeamHit() -> void:
	animateTarget()
	sprite.set_texture(activeState)

func onBeamLeave() -> void:
	animateTarget(true)
	sprite.set_texture(inactiveState)
