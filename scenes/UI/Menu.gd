extends Button

@export var scene_to_load_path: String

#var next_level_resource = load("res://scenes/UI/InGameSettings.tscn")
#var is_menu_screen_loaded = false
var menu_scene

func _ready():
	#menu_scene = preload(scene_to_load_path).instantiate()
	menu_scene = load(scene_to_load_path).instantiate()

func _on_pressed():
	var is_menu_screen_loaded = menu_scene.get_meta("is_menu_screen_loaded")
	var tree = get_tree()

	if is_menu_screen_loaded == false:
		tree.paused = true
		tree.get_root().add_child(menu_scene)
		menu_scene.set_meta("is_menu_screen_loaded",true)

	else:
		tree.paused = false
		tree.get_root().remove_child(menu_scene)
		menu_scene.set_meta("is_menu_screen_loaded",false)


	# FUNZIONA MA SOSTITUISCE LA SCENA COMPETAMENTE
	#tree.change_scene_to_file("res://scenes/UI/InGameSettings.tscn")

#
