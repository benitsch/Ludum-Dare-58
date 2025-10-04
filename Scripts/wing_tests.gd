extends Control

var running = false


func _on_test_button_pressed() -> void:
	if running:
		get_tree().reload_current_scene()
	else:
		$ButterflyWing.fallDown()
		$ButterflyWing2.fallDown()
	
	running = true
	
