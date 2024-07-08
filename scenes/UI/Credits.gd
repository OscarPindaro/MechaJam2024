extends Button

@export var credits_path : String

func _on_pressed():
	var credits = load(credits_path).instantiate()
	var tree = get_tree()
	tree.get_root().add_child(credits)
