extends Control

var userPressedStartButton = false
var currentShakes = 0
var maxShakesAllowed = 4

func _on_start_button_pressed() -> void:
	$Camera2D/AnimationPlayer.play("ZoomOut")
	userPressedStartButton = true
	#get_tree().change_scene_to_file("res://Scenes/level1.tscn")
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if userPressedStartButton && event is InputEventKey:
		if event.keycode == KEY_A || event.keycode == KEY_D:
			currentShakes += 1
			$MainButterfly/ShakerComponent2D.play_shake()
			$ButterflyBoard/ShakerComponent2D.play_shake()
			if currentShakes == 1:
				$ButterflyWing.fallDown()
