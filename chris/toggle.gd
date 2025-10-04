extends Area2D

# Export variable - drag your wall node here in the Inspector
@export var target_wall: AnimatableBody2D
@export_enum("Clockwise:90", "Counterclockwise:-90") var rotation_direction: int = 90
@export var static_sprite: Sprite2D  # Das Sprite das sich nicht drehen soll
@export var start_position_on: bool = false  # false = aus (links), true = ein (rechts)

# Toggle state
var is_right = false
var can_toggle = true
var static_sprite_offset: Vector2 = Vector2.ZERO

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)
	
	# Set start position based on export variable
	is_right = start_position_on
	
	# Set initial toggle rotation
	if is_right:
		rotation_degrees = 30  # On position (right)
		# Rotate wall to start position if assigned
		if target_wall:
			target_wall.rotation = target_wall.rotation + deg_to_rad(rotation_direction)
	else:
		rotation_degrees = -30  # Off position (left)
	
	# Set static sprite as top_level if assigned
	if static_sprite:
		# Speichere den ursprünglichen Offset BEVOR wir top_level setzen
		static_sprite_offset = static_sprite.position
		# Jetzt setze top_level
		static_sprite.top_level = true

func _process(_delta):
	# Keep static sprite at toggle position + offset without rotation
	if static_sprite:
		static_sprite.global_position = global_position + static_sprite_offset

func _on_body_entered(body):
	# Check if it's a CharacterBody2D (the player)
	if body is CharacterBody2D and can_toggle:
		toggle_switch()

func toggle_switch():
	can_toggle = false
	is_right = !is_right
	
	# Animate toggle visual rotation
	var tween_toggle = create_tween()
	tween_toggle.set_trans(Tween.TRANS_CUBIC)
	tween_toggle.set_ease(Tween.EASE_IN_OUT)
	
	var toggle_rotation = -30.0  # Off position (left)
	if is_right:
		toggle_rotation = 30.0  # On position (right)
	
	tween_toggle.tween_property(self, "rotation_degrees", toggle_rotation, 0.3)
	
	# Rotate the wall
	if target_wall:
		rotate_wall()
	
	# Prevent rapid toggling
	await get_tree().create_timer(0.5).timeout
	can_toggle = true

func rotate_wall():
	if not target_wall:
		return
	
	# Create a tween for smooth rotation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Calculate target rotation based on selected direction
	var target_rotation = 0.0
	if is_right:
		target_rotation = target_wall.rotation + deg_to_rad(rotation_direction)  # Rotate to selected direction
	else:
		target_rotation = target_wall.rotation - deg_to_rad(rotation_direction)
	
	# Animate the rotation over 1 second
	tween.tween_property(target_wall, "rotation", target_rotation, 1.0)
