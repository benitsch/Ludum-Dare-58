extends Control

var userPressedStartButton = false
var currentShakes = 0
var maxShakesAllowed = 5
var wings = []

var last_input_time := 0.0
var input_cooldown := 0.5

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer

func _ready() -> void:
	wings = [
		$ButterflyWing,
		$ButterflyWing2,
		$ButterflyWing3,
		$ButterflyWing4
	]
	SceneTransitionAnimation.play("fade_out")
	
func _on_start_button_pressed() -> void:
	userPressedStartButton = true
	$Camera2D/AnimationPlayer.play("ZoomOut")
	$StartButton.queue_free()

func _input(event: InputEvent) -> void:
	if not userPressedStartButton:
		return

	if event is InputEventKey and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_input_time >= input_cooldown:
			last_input_time = now
			handle_shake()

func handle_shake() -> void:
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
