extends AnimationArea2D

@onready var rod := $ToggleRod

var isStandingInSwitch := false
var delay := 0.0

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)

func onBodyEntered(_body) -> void:
	isStandingInSwitch = true
	moveRod()

func onBodyExited(_body) -> void:
	isStandingInSwitch = false
	moveRod()

func moveRod() -> void:
	var rodRotation := PI/6 # 30 degree
	
	if !isStandingInSwitch:
		rodRotation = -rodRotation
	
	rotateNode(rod, rodRotation)

func _physics_process(delta: float) -> void:
	if not isStandingInSwitch or target is not StaticBody2D:
		return
	
	delay += delta
	
	if delay > 0.5:
		delay = 0.0
		rotateTarget(angleModification, 0.4)
