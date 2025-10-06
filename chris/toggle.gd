extends Area2D

# Export variable - drag your wall node here in the Inspector
@export var target_wall: Node2D
@export_enum("Clockwise:1", "Counterclockwise:-1") var rotation_dir: int = 1
@export var rotation_degree = 90
@export var is_triggered: bool = false  # false = aus (links), true = ein (rechts)

# Toggle state
var can_toggle = false
var static_sprite_offset: Vector2 = Vector2.ZERO
var rotation_direction : float

@onready var rodSprite: Sprite2D = $ToggleRod

func _ready():
	if target_wall == null: return
	can_toggle = true
	rotation_direction = rotation_degree * rotation_dir
	
	# Set initial toggle rotation
	if is_triggered:
		rodSprite.rotation = rodSprite.rotation + deg_to_rad(30)
		target_wall.rotation = target_wall.rotation + deg_to_rad(rotation_direction)
	else:
		rodSprite.rotation = rodSprite.rotation - deg_to_rad(30)

func _on_body_entered(body):
	if !can_toggle: return
	can_toggle = false
	if body is CharacterBody2D: trigger_switch()
	await get_tree().create_timer(1.1).timeout
	can_toggle = true

func trigger_switch():
	is_triggered = !is_triggered
	
	# Animate toggle visual rotation
	var tween_toggle = create_tween()
	tween_toggle.set_trans(Tween.TRANS_CUBIC)
	tween_toggle.set_ease(Tween.EASE_IN_OUT)
	
	# Create a tween for smooth rotation
	var tween_wall = create_tween()
	tween_wall.set_trans(Tween.TRANS_CUBIC)
	tween_wall.set_ease(Tween.EASE_IN_OUT)
	
	# Calculate target rotation based on selected direction
	var toggle_rotation = 0.0 
	var wall_rotation = 0.0
	if is_triggered: 
		toggle_rotation = rodSprite.rotation + deg_to_rad(60.0)  # On position (right)
		wall_rotation = target_wall.rotation + deg_to_rad(rotation_direction)
	else: 
		toggle_rotation = rodSprite.rotation - deg_to_rad(60.0)
		wall_rotation = target_wall.rotation - deg_to_rad(rotation_direction)
	
	# Animate toggle and wall
	tween_toggle.tween_property(rodSprite, "rotation", toggle_rotation, 0.3)
	tween_wall.tween_property(target_wall, "rotation", wall_rotation, 1.0)
