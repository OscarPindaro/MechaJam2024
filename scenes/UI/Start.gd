extends Button

@export var game_path: String
# Called when the node enters the scene tree for the first time.

func _on_pressed():
	var tree = get_tree()
	tree.change_scene_to_file(game_path)
