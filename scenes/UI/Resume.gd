extends Button


## Called when the node enters the scene tree for the first time.
#func _ready():
#	print('qui')
#	var parent = $IngameMenu


func _on_pressed():
	var tree = get_tree()
	#tree.paused = false
	
	# Changes an attribute of the "IngameMenu" Control 
	#(Parent control of the InGameSettings.tscn scene) and removes it from the current tree
	#$"../../../..".set_meta("is_menu_screen_loaded",false)
	tree.get_root().remove_child($"../../../..")

