extends Area2D

@export_group("Jump")
@export var set_jump_allowed: bool = false;
@export var jump_allowd: bool = false;
@export var set_air_jump_count: bool = false;
@export var air_jump_count: int = 0;

@export_group("Dash")
@export var set_dash_allowed: bool = false;
@export var dash_allowed: bool = false;
@export var set_air_dash_count: bool = false;
@export var air_dash_count: int = 0;


func _init() -> void:
	connect("body_entered", body_entered)


func body_entered(body: Node2D) -> void:
	if body is Player:
		if set_jump_allowed:
			PlayerState.can_jump = jump_allowd;
		if set_air_jump_count:
			PlayerState.air_jump_amount = air_jump_count;
		if set_dash_allowed:
			PlayerState.can_dash = dash_allowed;
		if set_air_dash_count:
			PlayerState.air_dash_amount = air_dash_count;
		body.reset_animator()
