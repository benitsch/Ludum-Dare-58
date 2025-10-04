extends Control

var userPressedStartButton = false
var currentShakes = 0
var maxShakesAllowed = 4

func _on_start_button_pressed() -> void:
	$Camera2D/AnimationPlayer.play("ZoomOut")
	userPressedStartButton = true
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if userPressedStartButton && event is InputEventKey:
		if Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right"):
			currentShakes += 1
			$MainButterfly/ShakerComponent2D.play_shake()
			$ButterflyBoard/ShakerComponent2D.play_shake()
			# TODO randomly choose multiple butterfly wings to fall down on different currentShakes value (until maxShakesAllowed is reached)
			if currentShakes == 1:
				# TODO animate glide down
				$ButterflyWing.fallDown()
			if currentShakes == 4:
				$MainButterfly.fallDown()
				# TODO start level1 scene when main butterfly is out of view
				#get_tree().change_scene_to_file("res://Scenes/level1.tscn")
