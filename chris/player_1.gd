extends CharacterBody2D

# Movement variables
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get input direction: -1 for left, 1 for right, 0 for no input
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Apply horizontal movement
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# Slow down when no input (friction)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Move the player
	move_and_slide()
