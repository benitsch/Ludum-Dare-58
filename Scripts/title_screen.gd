extends Control

var userPressedStartButton := false
var mainButterflyIsFalling := false
var allShakesDone := 0
var currentShakeCounterForWingFallDown := 0
var maxShakesAllowed := 15
var shakesPerWing := 3
var wingsToFallDown := []

var last_input_time := 0.0
var input_cooldown := 0.25

@onready var SceneTransitionAnimation = %SceneTransitionAnimation
@onready var ShakeButtons = %ShakeButtons

func _ready() -> void:
	wingsToFallDown = [
		%WingLeftDown,
		%WingLeftUp,
		%WingRightUp,
		%WingRightDown
	]
	AudioPlayer.change_music("title");
	# ShakeButtons initially invisible & transparent
	ShakeButtons.visible = true
	ShakeButtons.modulate.a = 0.0

func _on_start_button_pressed() -> void:
	if userPressedStartButton:
		return
	
	AudioPlayer.change_music("game");
	userPressedStartButton = true
	%CameraAnimationPlayer.play("ZoomOut")
	%AnimPlayer.play("idle")

	
	if is_instance_valid(%StartButton):
		var tween = get_tree().create_tween()
		tween.tween_property(%StartButton, "modulate:a", 0.0, 0.5)
		await tween.finished
		if is_instance_valid(%StartButton):
			%StartButton.queue_free()

	showShakeButtons()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# When main butterfly falls down and leaves the screen
	SceneTransitionAnimation.play("fade_in")
	await SceneTransitionAnimation.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")

func _input(event: InputEvent) -> void:
	if not userPressedStartButton:
		return

	if event is InputEventKey and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		# Delete ShakeButtons, because User has already pressed A/D buttons
		if %AnimPlayer.get_animation() != "wiggle":
			%AnimPlayer.play("wiggle")

		if is_instance_valid(ShakeButtons):
			hideShakeButtons()

		# Add input delay to avoid key spamming
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_input_time >= input_cooldown:
			last_input_time = now
			handle_shake()

func handle_shake() -> void:
	allShakesDone += 1
	currentShakeCounterForWingFallDown += 1
	playShakes()
	
	if currentShakeCounterForWingFallDown >= shakesPerWing:
		currentShakeCounterForWingFallDown = 0
		wingFallDown()
	
	if !mainButterflyIsFalling && allShakesDone >= maxShakesAllowed:
		mainButterflyIsFalling = true
		%MainButterflyBody.fallDown()
		%AnimPlayer.fallDown()
		%MainButterflyShakerComponent2D.stop_shake()
		%ButterflyBoardShakerComponent2D.stop_shake()
		

func playShakes() -> void:
	if !mainButterflyIsFalling:
		%MainButterflyShakerComponent2D.play_shake()
		%ButterflyBoardShakerComponent2D.play_shake()

func wingFallDown() -> void:
	if wingsToFallDown.size() > 0:
		var random_index = randi() % wingsToFallDown.size()
		var chosen_wing = wingsToFallDown[random_index]
		chosen_wing.reparent(%fallen_wings)
		chosen_wing.fallDown()
		wingsToFallDown.remove_at(random_index)
	else: 
		%SceneTransitionAnimation.reparent(%SceneTransitionAnimation.get_parent())

func showShakeButtons() -> void:
	await get_tree().create_timer(1.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(ShakeButtons, "modulate:a", 1.0, 1.5)
	await get_tree().create_timer(3.5).timeout
	if is_instance_valid(%ButtonAShakerComponent2D):
		%ButtonAShakerComponent2D.play_shake()
		%ButtonBShakerComponent2D2.play_shake()

func hideShakeButtons() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(ShakeButtons, "modulate:a", 0.0, 1.0)
