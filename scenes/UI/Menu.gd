extends Button

@export var scene_to_load_path: String

#var next_level_resource = load("res://scenes/UI/InGameSettings.tscn")
#var is_menu_screen_loaded = false
var menu_scene

func _ready():
	#menu_scene = preload(scene_to_load_path).instantiate()
	menu_scene = load(scene_to_load_path).instantiate()

func _on_pressed():
	%PauseSymbol.visible = false
	var is_menu_screen_loaded = menu_scene.get_meta("is_menu_screen_loaded")
	var tree = get_tree()

	if is_menu_screen_loaded == false:
		tree.paused = true
		tree.get_root().add_child(menu_scene)
		menu_scene.set_meta("is_menu_screen_loaded",true)
		%Play_pause.disabled = true
		tree.get_root().child_exiting_tree.connect(enable_play_pause)

	else:
		tree.paused = false
		tree.get_root().remove_child(menu_scene)
		menu_scene.set_meta("is_menu_screen_loaded",false)
		%Play_pause.disabled = false


	# FUNZIONA MA SOSTITUISCE LA SCENA COMPETAMENTE
	#tree.change_scene_to_file("res://scenes/UI/InGameSettings.tscn")

func enable_play_pause(node):
	if node == menu_scene:
		%Play_pause.disabled = false
