extends AnimationArea2D

@export var initialState := false
var triggerOnce := true

@onready var buttonSprite := $Sprite2D

var inactiveTexture: Texture2D = preload("res://assets/Arts-WIP/PushButton01.png")
var activeTexture: Texture2D = preload("res://assets/Arts-WIP/PushButton02.png")
var activationState := false

func _init() -> void:
	activationState = initialState

func _ready() -> void:
	setTexture()
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)

func setTexture() -> void:
	if activationState:
		buttonSprite.texture = activeTexture
	else:
		buttonSprite.texture = inactiveTexture

func onBodyEntered(_body) -> void:
	if triggerOnce and activationState != initialState:
		return
	
	activationState = not activationState
	setTexture()
	
	if positionModification != DEFAULT_POSITION:
		repositionTarget(positionModification, 0.3)
	if angleModification != DEFAULT_ANGLE:
		rotateTarget(angleModification, 0.3)

func onBodyExited(_body) -> void:
	if triggerOnce:
		return
	
	activationState = not activationState
	#todo
