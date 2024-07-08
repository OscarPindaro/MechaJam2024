extends Button

signal pressed_unpaused()

func _on_pressed():
	if !get_tree().paused:
		pressed_unpaused.emit()
