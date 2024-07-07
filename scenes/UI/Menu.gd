extends Button

var next_level_resource = preload("res://scenes/UI/InGameSettings.tscn")




func _on_pressed():
	var next_level = next_level_resource.instantiate()
	add_child(next_level)
	
