extends CharacterBody2D

# Movement variables
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Jump control
@export var jump_available: bool = true

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump (only if jump_available is true)
	if Input.is_action_pressed("ui_accept") and is_on_floor() and jump_available:
		velocity.y = JUMP_VELOCITY
	
	# Get input direction from arrow keys OR WASD
	var direction = 0.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction += 1.0
	
	# Apply horizontal movement
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# Slow down when no input (friction)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Move the player
	move_and_slide()
