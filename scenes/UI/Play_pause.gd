extends Button


func _on_pressed():
	get_tree().paused = !get_tree().paused
	%PauseSymbol.visible = !%PauseSymbol.visible
	print(get_tree().paused)