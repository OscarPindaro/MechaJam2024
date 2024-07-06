extends Node2D

@export use_map: bool = true
@export var map_path: NodePath
var map_node: Map

@onready var curr_mecha: BaseMecha = $BaseMecha 
@onready var movement_controller: ControllerMovement = $ControllerMovement

# Called when the node enters the scene tree for the first time.
func _ready():
	if use_map:
		map_node = get_node(map_path)
	else:
		push_warning("Map not setted!!!!")



func _input(event):
	if use_map:
		if event is InputEventMouseButton and event.is_pressed():
			var mouse_position: Vector2 = get_global_mouse_position()
			var target_cell: Vector2i = get_coord_in_map(mouse_position)

			var mecha_cell: Vector2i = get_coord_in_map(curr_mecha.position)
			
			
			# can move if there is no cardboard
			var can_move: bool  = ! map_node.is_cell_cardboard(target_cell)


			if can_move and target_cell != mecha_cell:
				# compute best path
				var cell_path: Array[Vector2i] = movement_controller.compute_id_path(mecha_cell, target_cell)

				# convert to local transform? maybe inside the player
				var position_path: Array[Vector2]= []
				for cell in cell_path:
					position_path.append(get_center_tile_pos_from_cord(cell))
				curr_mecha.move_along_path(position_path)
				# curr_mecha.move_to(get_center_tile_pos_from_cord(target_cell))	



		




func get_coord_in_map(pos: Vector2) -> Vector2i:
	var localized = map_node.to_local(pos)
	return map_node.tilemap.local_to_map(localized)

func get_center_tile_pos_from_cord(coord: Vector2i) -> Vector2:
	var out_pos_local: Vector2  =map_node.tilemap.map_to_local(coord)
	var out_pos_global: Vector2 = get_parent().to_global(out_pos_local)
	return out_pos_global
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# paint the current position of the MAP
	var mouse_position: Vector2 = get_global_mouse_position()
	var mouse_cell: Vector2i = get_coord_in_map(mouse_position)


	# if on cardboard or some other object, draw red
	if use_map:
		var is_carboard: bool = map_node.is_cell_cardboard(mouse_cell)
		if is_carboard:
			map_node.draw_selection(mouse_cell, false)
		# else draw green
		else:
			map_node.draw_selection(mouse_cell, true)

