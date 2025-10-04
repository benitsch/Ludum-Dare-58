extends Control

var userPressedStartButton = false
var currentShakes = 0
var maxShakesAllowed = 5

var wings = []

func _ready() -> void:
	wings = [
		$ButterflyWing,
		$ButterflyWing2,
		$ButterflyWing3,
		$ButterflyWing4
	]

func _on_start_button_pressed() -> void:
	$Camera2D/AnimationPlayer.play("ZoomOut")
	userPressedStartButton = true

func _input(event: InputEvent) -> void:
	if userPressedStartButton && event is InputEventKey:
		if Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right"):
			currentShakes += 1
			playShakes()
			wingFallDown()

			if currentShakes >= maxShakesAllowed:
				$MainButterfly.fallDown()

func playShakes() -> void:
	$MainButterfly/ShakerComponent2D.play_shake()
	$ButterflyBoard/ShakerComponent2D.play_shake()

func wingFallDown() -> void:
	if wings.size() > 0:
		var random_index = randi() % wings.size()
		var chosen_wing = wings[random_index]
		chosen_wing.fallDown()
		wings.remove_at(random_index)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
