extends AnimationTrigger

class_name LightCollector

func _init() -> void:
	onlyTriggerOnce = true

func onBeamHit() -> void:
	animateTarget()

func onBeamLeave() -> void:
	animateTarget(true)
