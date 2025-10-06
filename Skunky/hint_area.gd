extends Area2D


@export var dependantAreas: Array[Area2D] = []
var dependants_triggered: int
var player_inside: bool


func _ready() -> void:
	modulate = Color.TRANSPARENT
	connect("body_entered", body_entered)
	connect("body_exited", body_exited)
	for area in dependantAreas:
		var triggered := false
		area.connect("body_entered", func(body: Node2D):
			if not body is Player: return
			if triggered: return
			triggered = true
			dependants_triggered += 1
			if dependants_triggered != dependantAreas.size(): return
			if not player_inside: return
			var property_tween := create_tween()
			property_tween.tween_property(self, "modulate", Color.WHITE, 1)
		)


func body_entered(body: Node2D) -> void:
	if not body is Player: return
	player_inside = true
	if dependants_triggered != dependantAreas.size(): return
	var property_tween := create_tween()
	property_tween.tween_property(self, "modulate", Color.WHITE, 1)


func body_exited(body: Node2D) -> void:
	if not body is Player: return
	player_inside = false
	var property_tween := create_tween()
	property_tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
