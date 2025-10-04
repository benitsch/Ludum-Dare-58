extends CharacterBody2D


@export var ascend_gravity: float = 1980
@export var descend_gravity: float = 980
@export var jump_height: float = 300
@export var air_jump_height: float = 200
@export var speed: float = 1000
@export var floor_acceleration := 0.1
@export var floor_deceleration := 0.05
@export var air_acceleration := 0.2
@export var air_deceleration := 0.4
@export var dashing_time: float = 1
@export var dash_length: float = 200

var air_jump_amount: int = 1
var cur_air_jumps:= air_jump_amount
var can_jump: bool = true
var air_dash_amount: int = 1
var cur_air_dashes:= air_dash_amount
var can_dash: bool = true

var dashing: bool = false
var dash_timer: float = 0


func _physics_process(delta: float) -> void:
	var input := Input.get_axis("move_left", "move_right");
	var horizontal_half_time := lerpf(
		floor_deceleration if is_on_floor() else air_deceleration,
		floor_acceleration if is_on_floor() else air_acceleration,
		abs(input)
	);
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += delta * descend_gravity;
		else:
			velocity.y += delta * ascend_gravity;
	else:
		cur_air_jumps = air_jump_amount;
	velocity.x = SkunkyHelper.lerp_smooth(
			velocity.x,
			input * speed,
			delta,
			horizontal_half_time
	);
	move_and_slide();
	input = 0;


func on_ground_touch():
	cur_air_jumps = air_jump_amount;
	cur_air_dashes = air_dash_amount;


func try_jump():
	if is_on_floor():
		velocity.y = -sqrt(2 * ascend_gravity * jump_height);
	elif cur_air_jumps > 0:
		velocity.y = -sqrt(2 * ascend_gravity * air_jump_height);
		cur_air_jumps -= 1;


func try_dash():
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if can_jump:
			try_jump();
	if event.is_action_pressed("dash"):
		if can_dash:
			try_dash();
