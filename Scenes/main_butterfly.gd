extends Sprite2D

func fallDown() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position:y", $".".position.y + 500, 1.0)
