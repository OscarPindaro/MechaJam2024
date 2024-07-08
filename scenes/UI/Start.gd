extends Button

@export var main_screen_path: String
# Called when the node enters the scene tree for the first time.



func _on_pressed():
	var tree = get_tree()
	tree.change_scene_to_file(main_screen_path)

#
