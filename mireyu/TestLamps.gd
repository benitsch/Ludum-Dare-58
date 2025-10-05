extends Node2D

@onready var myMirror := $Mirror2

func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	
	if Input.is_action_just_pressed("move_left"):
		#print("left")
		myMirror.rotate(-PI/16)
	elif Input.is_action_just_pressed("move_right"):
		#print("right")
		myMirror.rotate(PI/16)
