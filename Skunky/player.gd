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
@export var dashing_time: float = .25
@export var dash_length: float = 300

var direction: int
var cur_air_jumps := PlayerState.air_jump_amount
var cur_air_dashes := PlayerState.air_dash_amount

var dashing: bool = false
var dash_timer: float = 0

var objectList : Array[Node2D]

func _physics_process(delta: float) -> void:
	var input := Input.get_axis("move_left", "move_right");
	if not is_zero_approx(input):
		direction = 1 if input > 0 else -1;
	if dashing:
		if dash_timer < dashing_time and not is_on_wall():
			dash_timer += delta;
			move_and_slide();
			return
		dash_timer = 0;
		dashing = false;
	var horizontal_half_time := lerpf(
		floor_deceleration if is_on_floor() else air_deceleration,
		floor_acceleration if is_on_floor() else air_acceleration,
		absf(input)
	);
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += delta * descend_gravity;
		else:
			velocity.y += delta * ascend_gravity;
	else:
		on_ground_touch();
	velocity.x = SkunkyHelper.lerp_smooth(
			velocity.x,
			input * speed,
			delta,
			horizontal_half_time
	);
	move_and_slide();


func on_ground_touch():
	cur_air_jumps = PlayerState.air_jump_amount;
	cur_air_dashes = PlayerState.air_dash_amount;


func try_jump():
	if not PlayerState.can_jump: return;
	if is_on_floor():
		velocity.y = -sqrt(2 * ascend_gravity * jump_height);
	elif cur_air_jumps > 0:
		velocity.y = -sqrt(2 * ascend_gravity * air_jump_height);
		cur_air_jumps -= 1;


func try_dash():
	if not PlayerState.can_dash: return;
	if dashing or cur_air_dashes <= 0: return;
	dashing = true;
	velocity.y = 0;
	velocity.x = direction * dash_length / dashing_time;
	cur_air_dashes -= 1;


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		try_jump();
	if event.is_action_pressed("dash"):
		try_dash();

func _on_push_area_body_entered(body: Node2D) -> void:
	objectList.append(body)
	set_collision_mask_value(3, false)

func _on_push_area_body_exited(body: Node2D) -> void:
	objectList.erase(body)
	
	if objectList.size() == 0:
		set_collision_mask_value(3, true)
