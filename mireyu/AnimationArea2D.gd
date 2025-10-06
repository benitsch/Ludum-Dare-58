extends Area2D

class_name AnimationArea2D

const DEFAULT_ANGLE := 0.0
const DEFAULT_DURATION := 0.15
const DEFAULT_POSITION := Vector2.ZERO

@export var target: Node2D
@export var positionModification := Vector2.ZERO
@export_range(-360, 360, 0.001, "radians_as_degrees") var angleModification: float = DEFAULT_ANGLE
@export_range(0, 10, 0.05) var durationModification := 0.0

func rotateTarget(rotationValue: float, duration := DEFAULT_DURATION) -> void:
	if target is not Node2D:
		return
	
	rotateNode(target, rotationValue, duration)

func rotateNode(node: Node2D, rotationValue: float, duration: float = DEFAULT_DURATION) -> void:
	animateNode(node, "rotation", node.rotation + rotationValue, duration)


func repositionTarget(positionValue: Vector2, duration := DEFAULT_DURATION) -> void:
	if target is not Node2D:
		return
	
	repositionNode(target, positionValue, duration)

func repositionNode(node: Node2D, positionValue: Vector2, duration := DEFAULT_DURATION) -> void:
	animateNode(node, "position", node.position + positionValue, duration)

func animateNode(node: Node2D, property: NodePath, finalValue, duration := DEFAULT_DURATION) -> void:
	var tween_toggle = create_tween()
	tween_toggle.set_trans(Tween.TRANS_CUBIC)
	tween_toggle.set_ease(Tween.EASE_IN_OUT)	
	tween_toggle.tween_property(node, property, finalValue, calculateDurationWithModification(duration))

func calculateDurationWithModification(duration: float) -> float:
	return duration + durationModification

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	if target is not Node2D:
		warnings.append("Target is missing")
	
	return warnings
