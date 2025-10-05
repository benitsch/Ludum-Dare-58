extends StaticBody2D

@export var target: StaticBody2D
@export_range(0, 360, 0.1, "radians_as_degrees") var angleModification: float = 0.0
@export var positionModification := Vector2.ZERO

const propertyConditions: Dictionary = {
	"positionModification": "position",
	"angleModification": "rotation"
}

var wasTriggered:= false

func onBeamHit() -> void:
	if not target or wasTriggered:
		return
	
	wasTriggered = true
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var changes: Dictionary = {}
	
	if positionModification != Vector2.ZERO:
		changes["position"] = target.position + positionModification
	
	if angleModification != 0.0:
		changes["rotation"] = target.rotation + angleModification
	
	for animation in changes:
		tween.tween_property(target, animation, changes[animation], 1.0)
