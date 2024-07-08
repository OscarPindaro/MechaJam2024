extends Button

@export var main_menu_path : String

func _on_pressed():
	var tree = get_tree()
	tree.change_scene_to_file(main_menu_path)
	$"../../../..".set_meta("is_menu_screen_loaded",false)
	tree.get_root().remove_child($"../../../..")
	tree.paused = false
