extends Area2D

@export var target: StaticBody2D
@export_range(-360, 360, 0.1, "radians_as_degrees") var angle: float = PI/32

@onready var rod := $ToggleRod

var isStandingInSwitch := false
var delay := 0.0

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)

func onBodyEntered(body) -> void:
	isStandingInSwitch = true
	moveRod()

func onBodyExited(body) -> void:
	isStandingInSwitch = false
	moveRod()

func moveRod() -> void:
	var rotation := PI/6 # 30 degree
	
	if !isStandingInSwitch:
		rotation = -rotation
	
	rotateNode(rod, rotation)

func rotateNode(node: Node2D, rotation: float, duration: float = 0.15) -> void:
	var tween_toggle = create_tween()
	tween_toggle.set_trans(Tween.TRANS_CUBIC)
	tween_toggle.set_ease(Tween.EASE_IN_OUT)
	
	tween_toggle.tween_property(node, "rotation", node.rotation + rotation, duration)

func _physics_process(delta: float) -> void:
	if not isStandingInSwitch or target is not StaticBody2D:
		return
	
	delay += delta
	
	if delay > 0.5:
		delay = 0.0
		rotateNode(target, angle, 0.4)
