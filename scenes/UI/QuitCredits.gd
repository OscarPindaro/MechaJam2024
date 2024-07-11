extends Button


func _on_pressed():
	var tree = get_tree()
	tree.get_root().remove_child($"../../../..")
