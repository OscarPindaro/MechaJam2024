extends Node2D

@export var use_map: bool = true
@export var map_path: NodePath
var map_node: Map
@export var start_mecha_path: NodePath

var curr_mecha: BaseMecha
@onready var movement_controller: ControllerMovement = $ControllerMovement
# get all mechas
var mechas_list: Array[BaseMecha]

# Called when the node enters the scene tree for the first time.
func _ready():
	if use_map:
		map_node = get_node(map_path)
	else:
		push_warning("Map not setted!!!!")
	mechas_list.assign(find_children("*", "BaseMecha", true, false))

	for mecha in mechas_list:
		mecha.mecha_selected.connect(on_mecha_selection)


	if start_mecha_path != NodePath(""):
		curr_mecha = get_node(start_mecha_path)
		assert(curr_mecha in mechas_list, "Starting mecha should be in the mecha list	")

func _input(event):
	if use_map and curr_mecha != null:
		# await curr_mecha.input_capture_ended
		# await get_tree().create_timer(0.2).timeout
		if event is InputEventMouseButton and event.is_pressed():
			var mouse_position: Vector2 = get_global_mouse_position()
			var target_cell: Vector2i = get_coord_in_map(mouse_position)
			var mecha_cell: Vector2i = get_coord_in_map(curr_mecha.position)
			
			
			# # can move if there is no cardboard
			# var mecha_cells: Array[Vector2i] = []
			# for mecha in mecha_list:
			# 	mecha_cells.append(get_coord_in_map(mecha.position))
			var can_move: bool  = can_mecha_move(target_cell)

			if can_move:
				# compute best path
				var cell_path: Array[Vector2i] = movement_controller.compute_id_path(mecha_cell, target_cell)

				# convert to local transform? maybe inside the player
				var position_path: Array[Vector2]= []
				for cell in cell_path:
					position_path.append(get_center_tile_pos_from_cord(cell))
				curr_mecha.move_along_path(position_path)
				# curr_mecha.move_to(get_center_tile_pos_from_cord(target_cell))

func can_mecha_move(cell: Vector2i):
	var mecha_cells: Array[Vector2i] = []
	for mecha in mechas_list:
		mecha_cells.append(get_coord_in_map(mecha.position))
	
	var can_move = true
	for mecha_cell in mecha_cells:
		can_move = can_move and mecha_cell != cell
	can_move = can_move and ! map_node.is_cell_cardboard(cell)
	return can_move

func on_mecha_selection(mecha: BaseMecha):
	if curr_mecha != null:
		curr_mecha.set_select_mecha(false)
	curr_mecha = mecha


func get_coord_in_map(pos: Vector2) -> Vector2i:
	var localized = map_node.to_local(pos)
	return map_node.tilemap.local_to_map(localized)

func get_center_tile_pos_from_cord(coord: Vector2i) -> Vector2:
	var out_pos_local: Vector2  =map_node.tilemap.map_to_local(coord)
	var out_pos_global: Vector2 = get_parent().to_global(out_pos_local)
	return out_pos_global
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# paint the current position of the MAP
	
	# if on cardboard or some other object, draw red
	if use_map:
		var mouse_position: Vector2 = get_global_mouse_position()
		var mouse_cell: Vector2i = get_coord_in_map(mouse_position)


		var is_carboard: bool = map_node.is_cell_cardboard(mouse_cell)
		if is_carboard:
			map_node.draw_selection(mouse_cell, false)
		# else draw green
		else:
			map_node.draw_selection(mouse_cell, true)

