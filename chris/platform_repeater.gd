extends Node2D

# Export variables - adjust these in the Inspector!
@export var repeat_count: int = 10  # How many times to repeat
@export var spacing: float = 500.0  # Distance between each platform
@export var platform_scene: PackedScene  # Drag your platform scene here

# Or if you want to duplicate an existing child node:
@export var template_node_path: NodePath  # Path to the node to duplicate
@export var use_template: bool = false  # Toggle between scene vs template

func _ready():
	if use_template and template_node_path:
		duplicate_from_template()
	elif platform_scene:
		instantiate_from_scene()

func duplicate_from_template():
	var template = get_node_or_null(template_node_path)
	if not template:
		push_error("Template node not found at path: " + str(template_node_path))
		return
	
	var start_position = template.position
	
	# Create copies
	for i in range(1, repeat_count):
		var duplicate = template.duplicate()
		duplicate.position = start_position + Vector2(spacing * i, 0)
		add_child(duplicate)

func instantiate_from_scene():
	if not platform_scene:
		push_error("No platform scene assigned!")
		return
	
	# Instantiate platforms
	for i in range(repeat_count):
		var instance = platform_scene.instantiate()
		instance.position = Vector2(spacing * i, 0)
		add_child(instance)
