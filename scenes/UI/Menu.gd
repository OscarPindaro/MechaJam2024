extends Button

#var next_level_resource = load("res://scenes/UI/InGameSettings.tscn")
var is_menu_screen_loaded = false
var menu_scene = preload("res://scenes/UI/InGameSettings.tscn").instantiate()


func _on_pressed():
	var tree = get_tree()

	if is_menu_screen_loaded == false:
		tree.paused = true
		

		tree.get_root().add_child(menu_scene)
		is_menu_screen_loaded = true
		
	else:
		tree.paused = false
		tree.get_root().remove_child(menu_scene)
		is_menu_screen_loaded = false
		
	
	# FUNZIONA MA SOSTITUISCE LA SCENA COMPETAMENTE
	#tree.change_scene_to_file("res://scenes/UI/InGameSettings.tscn")

#
