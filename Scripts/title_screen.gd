extends Control

var userPressedStartButton = false
var mainButterflyIsFalling = false
var currentShakes = 0
var maxShakesAllowed = 5
var wingsToFallDown = []

var last_input_time := 0.0
var input_cooldown := 0.5

@onready var SceneTransitionAnimation = %SceneTransitionAnimation/AnimationPlayer
@onready var ShakeButtons = %ShakeButtons

func _ready() -> void:
	wingsToFallDown = [
		%WingLeftDown,
		%WingLeftUp,
		%WingRightUp,
		%WingRightDown
	]
	# SceneTransitionAnimation is invisible in the editor for better development,
	# but we need the SceneTransitionAnimation visible
	%SceneTransitionAnimation.visible = true
	# ShakeButtons initially invisible & transparent
	ShakeButtons.visible = true
	ShakeButtons.modulate.a = 0.0
	SceneTransitionAnimation.play("fade_out")

func _on_start_button_pressed() -> void:
	userPressedStartButton = true
	$"../../Node/Camera2D/AnimationPlayer".play("ZoomOut")
	$StartButton.queue_free()
	showShakeButtons()

func _input(event: InputEvent) -> void:
	if not userPressedStartButton:
		return

	if event is InputEventKey and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		# Add input delay to avoid key spamming
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_input_time >= input_cooldown:
			last_input_time = now
			handle_shake()

func handle_shake() -> void:
	currentShakes += 1
	playShakes()
	wingFallDown()
	if !mainButterflyIsFalling && currentShakes >= maxShakesAllowed:
		mainButterflyIsFalling = true
		$"../../Node/MainButterfly/Body".fallDown()

func playShakes() -> void:
	$"../../Node/MainButterfly/Body/ShakerComponent2D".play_shake()
	$"../../Node/ButterflyBoard/ShakerComponent2D".play_shake()

func wingFallDown() -> void:
	if wingsToFallDown.size() > 0:
		var random_index = randi() % wingsToFallDown.size()
		var chosen_wing = wingsToFallDown[random_index]
		chosen_wing.fallDown()
		wingsToFallDown.remove_at(random_index)

func showShakeButtons() -> void:
	await get_tree().create_timer(1.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(ShakeButtons, "modulate:a", 1.0, 1.5)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# When main butterfly falls down and leaves the screen
	SceneTransitionAnimation.play("fade_in")
	await SceneTransitionAnimation.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
