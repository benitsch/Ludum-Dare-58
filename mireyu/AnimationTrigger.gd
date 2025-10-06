extends StaticBody2D

class_name AnimationTrigger

const DEFAULT_POSITION := Vector2.ZERO
const DEFAULT_ANGLE := 0.0

@export var target: Node2D
@export_range(0, 360, 0.1, "radians_as_degrees") var angleModification: float = DEFAULT_ANGLE
@export var positionModification := DEFAULT_POSITION
@export var shouldToggle := false
@export var onlyTriggerOnce := true

@onready var timer: Timer = Timer.new()

var isToggleOn := false
var wasTriggered := false
var modificationModifier := 1
var changes: Dictionary = {}
var isAnimating := false

func _ready() -> void:
	add_child(timer)
	timer.wait_time = 1.5
	timer.one_shot = true

func animateTarget(reset := false) -> void:
	if not target:
		return
	
	if onlyTriggerOnce and wasTriggered and not reset:
		return
	
	if not reset and timer.time_left > 0.0:
		return
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	discoverPositionModification()
	discoverAngleModification()
	
	wasTriggered = not reset
	
	if reset:
		for animation in changes:
			changes[animation]["target"] = changes[animation]["original"]
	
	isAnimating = true
	timer.start()
	
	for animation in changes:
		tween.tween_property(target, animation, changes[animation]["target"], 1.0)

func discoverPositionModification() -> void:
	if positionModification == DEFAULT_POSITION:
		return
	
	if not wasTriggered:
		changes["position"] = {}
		changes["position"]["original"] = target.position
	
	changes["position"]["target"] = target.position + calculateModifier(positionModification)
	
func discoverAngleModification() -> void:
	if angleModification == DEFAULT_ANGLE:
		return
	
	if not wasTriggered:
		changes["rotation"] = {}
		changes["rotation"]["original"] = target.rotation
	
	changes["rotation"] = target.rotation + calculateModifier(angleModification)

func calculateModifier(modifier):
	if shouldToggle and isToggleOn:
		return -modifier
	
	return modifier

func _on_timer_timeout():
	isAnimating = false
