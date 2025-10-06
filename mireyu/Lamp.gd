extends Node2D

@onready var ray = $RayCast2D
@onready var line = $Line2D
@onready var circle:= $RayCast2D/Circle

@export var maxBounces: int = 5
@export var beamLength: int = 1000

var beamPoints: Array[Vector2] = []
var currentStart: Vector2
var currentDirection: Vector2
var hitCollectors: Array[LightCollector] = []
var timeAccumulation := 0.0

func _process(delta: float) -> void:
	castLightBeam()
	dynamicLightCurve(delta)

func castLightBeam() -> void:
	beamPoints.clear()
	currentStart = global_position
	currentDirection = Vector2.DOWN #.rotated(global_rotation) #.rotated(rotation)
	beamPoints.append(to_local(currentStart))
	
	castLightUntilNextPoint(maxBounces)

	line.points = beamPoints
	line.width = 68
	line.gradient = preload("res://mireyu/LightGradient.tres")
	line.default_color = Color(1, 1, 0.3, 0.6) # yellowish light

func castLightUntilNextPoint(availableBounces: int) -> void:
	if availableBounces <= 0:
		return
	
	ray.global_position = currentStart
	ray.target_position = currentDirection * beamLength
	ray.force_raycast_update()
	circle.position = ray.target_position
	
	if ray.is_colliding():
		var collisionPoint = ray.get_collision_point()
		var collider = ray.get_collider()
		beamPoints.append(to_local(collisionPoint))

		if collider is Mirror:
			var normal: Vector2 = ray.get_collision_normal()
			var dot = normal.dot(collider.global_transform.x)

			if dot >= 0:
				return
			
			normal = normal.rotated(-rotation)
			currentDirection = currentDirection.normalized().bounce(normal)
			currentStart = collisionPoint + currentDirection.rotated(rotation) * 2.0
			
			castLightUntilNextPoint(availableBounces - 1)
		elif collider is LightCollector:
			if not hitCollectors.has(collider):
				hitCollectors.append(collider)
			collider.onBeamHit()
	else:
		beamPoints.append(to_local(ray.to_global(ray.target_position)))
		if not hitCollectors.is_empty():
			for collector in hitCollectors:
				collector.onBeamLeave()
			hitCollectors = []

func reflectMirror(direction: Vector2, collisionPoint: Vector2) -> void:
	# Get mirror normal and reflect
	var normal = ray.get_collision_normal()
	direction = direction.bounce(normal).normalized()
	global_position = collisionPoint + direction * 2.0

func dynamicLightCurve(delta: float) -> void:
	# slight pulsing of the light to the end
	var curve: Curve = line.width_curve
	timeAccumulation = fmod(timeAccumulation + delta, 2 * PI)
	curve.set_point_offset(1, 0.9 + sin(timeAccumulation) / 10)
