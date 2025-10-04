extends AnimationPlayer

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		# Delete the whole animation Node after fade_out animation is done
		# to allow user to click the "Start" button
		$"..".queue_free()
