extends Area2D

# Export variables
@export var sprite_off: Sprite2D  # Sprite wenn Button nicht gedrückt
@export var sprite_on: Sprite2D   # Sprite wenn Button gedrückt
@export var box_layer: int = 8    # Collision Layer für Boxen (z.B. Layer 4 = Bit 8)
@export var overlap_threshold: float = 0.2  # 20% Überlappung nötig
@export var debug_mode: bool = true  # Debug Ausgaben aktivieren

# Wall control
@export var target_wall: Node2D  # Die Wall die gesteuert werden soll
@export_enum("Remover", "Activator") var wall_mode: int = 0  # 0 = ausblendet wenn aktiv, 1 = einblendet wenn aktiv
@export var animation_duration: float = 0.5  # Dauer der Animation in Sekunden

# Button state
var is_pressed: bool = false
var overlapping_boxes: Array = []

# Signal für andere Objekte
signal button_pressed
signal button_released

func _ready():
	print("=== BoxButton Ready ===")
	print("collision_layer: ", collision_layer)
	print("collision_mask: ", collision_mask)
	print("box_layer: ", box_layer)
	print("sprite_off: ", sprite_off)
	print("sprite_on: ", sprite_on)
	print("target_wall: ", target_wall)
	print("wall_mode: ", "Remover" if wall_mode == 0 else "Activator")
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Set initial sprite state
	update_sprite_state()
	
	# Set initial wall state
	if target_wall:
		if wall_mode == 1:  # Activator mode
			# Start hidden
			set_wall_visible(false)
		# Remover mode starts visible (default)
	
	print("Initial sprite state set")

func _physics_process(_delta):
	# Check all overlapping bodies/areas
	check_overlap()

func _on_body_entered(body: Node2D):
	if debug_mode:
		print("Body entered: ", body.name, " | Layer: ", body.collision_layer)
	
	# Prüfe ob es eine Box ist (anhand der collision layer)
	if body is RigidBody2D or body is StaticBody2D or body is CharacterBody2D:
		if debug_mode:
			print("  -> Is physics body. Checking layer: ", body.collision_layer & box_layer)
		
		if body.collision_layer & box_layer:
			if body not in overlapping_boxes:
				overlapping_boxes.append(body)
				if debug_mode:
					print("  -> BOX ADDED! Total boxes: ", overlapping_boxes.size())

func _on_body_exited(body: Node2D):
	if debug_mode:
		print("Body exited: ", body.name)
	
	if body in overlapping_boxes:
		overlapping_boxes.erase(body)
		if debug_mode:
			print("  -> BOX REMOVED! Total boxes: ", overlapping_boxes.size())

func _on_area_entered(area: Node2D):
	if debug_mode:
		print("Area entered: ", area.name, " | Layer: ", area.collision_layer)
	
	# Falls Boxen als Area2D implementiert sind
	if area.collision_layer & box_layer:
		if area not in overlapping_boxes:
			overlapping_boxes.append(area)
			if debug_mode:
				print("  -> AREA BOX ADDED! Total boxes: ", overlapping_boxes.size())

func _on_area_exited(area: Node2D):
	if debug_mode:
		print("Area exited: ", area.name)
	
	if area in overlapping_boxes:
		overlapping_boxes.erase(area)
		if debug_mode:
			print("  -> AREA BOX REMOVED! Total boxes: ", overlapping_boxes.size())

func check_overlap():
	if overlapping_boxes.size() == 0:
		if is_pressed:
			is_pressed = false
			update_sprite_state()
			update_wall_state(false)
			emit_signal("button_released")
			if debug_mode:
				print("!!! BUTTON RELEASED !!!")
		return
	
	var should_be_pressed = false
	
	# Prüfe jede überlappende Box
	for box in overlapping_boxes:
		if not is_instance_valid(box):
			overlapping_boxes.erase(box)
			continue
		
		var overlap_percent = calculate_overlap_percentage(box)
		
		if debug_mode and Engine.get_physics_frames() % 60 == 0:  # Every 60 frames
			print("Box: ", box.name, " | Overlap: ", "%.1f" % (overlap_percent * 100), "%")
		
		if overlap_percent >= overlap_threshold:
			should_be_pressed = true
			break
	
	# Update button state if changed
	if should_be_pressed != is_pressed:
		is_pressed = should_be_pressed
		update_sprite_state()
		update_wall_state(is_pressed)
		
		if is_pressed:
			emit_signal("button_pressed")
			if debug_mode:
				print("!!! BUTTON PRESSED !!!")
		else:
			emit_signal("button_released")
			if debug_mode:
				print("!!! BUTTON RELEASED !!!")

func update_wall_state(button_active: bool):
	if not target_wall:
		return
	
	var should_show: bool
	
	if wall_mode == 0:  # Remover mode
		should_show = not button_active  # Hide when button active
	else:  # Activator mode
		should_show = button_active  # Show when button active
	
	if debug_mode:
		print("Wall update - Mode: ", "Remover" if wall_mode == 0 else "Activator", " | Show: ", should_show)
	
	animate_wall(should_show)

func animate_wall(show: bool):
	if not target_wall:
		return
	
	# Create tween for smooth animation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	if show:
		# Fade in and enable collision
		target_wall.modulate.a = 0
		target_wall.visible = true
		set_wall_collision(true)
		tween.tween_property(target_wall, "modulate:a", 1.0, animation_duration)
	else:
		# Fade out and disable collision
		tween.tween_property(target_wall, "modulate:a", 0.0, animation_duration)
		tween.tween_callback(func(): 
			target_wall.visible = false
			set_wall_collision(false)
		)

func set_wall_visible(visible: bool):
	if not target_wall:
		return
	target_wall.visible = visible
	target_wall.modulate.a = 1.0 if visible else 0.0
	set_wall_collision(visible)

func set_wall_collision(enabled: bool):
	if not target_wall:
		return
	
	# Disable/enable all collision shapes in the wall
	for child in target_wall.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", not enabled)

func calculate_overlap_percentage(box: Node2D) -> float:
	# Get button's collision shape
	var button_shape = get_collision_shape()
	if not button_shape:
		if debug_mode:
			print("ERROR: Button has no collision shape!")
		return 0.0
	
	# Get box's collision shape
	var box_shape = get_box_collision_shape(box)
	if not box_shape:
		if debug_mode:
			print("ERROR: Box ", box.name, " has no collision shape!")
		return 0.0
	
	# Calculate overlap based on x-axis
	var button_left = global_position.x - button_shape.x
	var button_right = global_position.x + button_shape.x
	var box_left = box.global_position.x - box_shape.x
	var box_right = box.global_position.x + box_shape.x
	
	# Calculate overlap
	var overlap_left = max(button_left, box_left)
	var overlap_right = min(button_right, box_right)
	var overlap_width = max(0, overlap_right - overlap_left)
	
	var box_width = box_shape.x * 2
	
	if box_width <= 0:
		return 0.0
	
	return overlap_width / box_width

func get_collision_shape() -> Vector2:
	# Find first CollisionShape2D child
	for child in get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape is RectangleShape2D:
				return shape.size / 2
			elif shape is CircleShape2D:
				return Vector2(shape.radius, shape.radius)
	return Vector2.ZERO

func get_box_collision_shape(box: Node2D) -> Vector2:
	# Find collision shape in box
	for child in box.get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape is RectangleShape2D:
				return shape.size / 2
			elif shape is CircleShape2D:
				return Vector2(shape.radius, shape.radius)
		elif child is CollisionPolygon2D:
			# Calculate bounding box from polygon points
			var polygon = child.polygon
			if polygon.size() > 0:
				var min_x = polygon[0].x
				var max_x = polygon[0].x
				var min_y = polygon[0].y
				var max_y = polygon[0].y
				
				for point in polygon:
					min_x = min(min_x, point.x)
					max_x = max(max_x, point.x)
					min_y = min(min_y, point.y)
					max_y = max(max_y, point.y)
				
				var width = max_x - min_x
				var height = max_y - min_y
				return Vector2(width / 2, height / 2)
	
	if debug_mode:
		print("WARNING: No collision shape found for ", box.name)
	return Vector2.ZERO

func update_sprite_state():
	if sprite_off and sprite_on:
		sprite_off.visible = not is_pressed
		sprite_on.visible = is_pressed
		if debug_mode:
			print("Sprites updated - Off visible: ", sprite_off.visible, " | On visible: ", sprite_on.visible)
	else:
		if debug_mode:
			print("ERROR: Sprites not assigned!")
