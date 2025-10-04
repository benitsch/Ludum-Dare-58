extends Control

var userPressedStartButton = false
var mainButterflyIsFalling = false
var currentShakes = 0
var maxShakesAllowed = 5
var wings = []

var last_input_time := 0.0
var input_cooldown := 0.5

@onready var SceneTransitionAnimation = $"../../Node/SceneTransitionAnimation/AnimationPlayer"

func _ready() -> void:
	wings = [
		$"../../Node/ButterflyLeftUp/WingLeftDown",
		$"../../Node/ButterflyLeftDown/WingLeftUp",
		$"../../Node/ButterflyRightUp/WingRightUp",
		$"../../Node/ButterflyRightDown/WingRightDown"
	]
	#SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fade_out")
	
func _on_start_button_pressed() -> void:
	userPressedStartButton = true
	$"../../Node/Camera2D/AnimationPlayer".play("ZoomOut")
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
	if !mainButterflyIsFalling && currentShakes >= maxShakesAllowed:
		mainButterflyIsFalling = true
		$"../../Node/MainButterfly/Body".fallDown()

func playShakes() -> void:
	$"../../Node/MainButterfly/Body/ShakerComponent2D".play_shake()
	$"../../Node/ButterflyBoard/ShakerComponent2D".play_shake()

func wingFallDown() -> void:
	if wings.size() > 0:
		var random_index = randi() % wings.size()
		var chosen_wing = wings[random_index]
		chosen_wing.fallDown()
		wings.remove_at(random_index)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	SceneTransitionAnimation.play("fade_in")
	await SceneTransitionAnimation.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
