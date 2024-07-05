extends Node2D

@export var map_path: NodePath
@onready var map_node: Map = get_node(map_path)

@onready var curr_mecha: BaseMecha = $BaseMecha 


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_position: Vector2 = get_local_mouse_position()
		print("aaaa", map_node.tilemap	)
		var target_cell: Vector2i = get_coord_in_map(mouse_position)

		var mecha_cell: Vector2i = get_coord_in_map(curr_mecha.position)

		if target_cell != mecha_cell:
			curr_mecha.move_to(get_center_tile_pos_from_cord(target_cell))

		




func get_coord_in_map(pos: Vector2) -> Vector2i:
	var localized = map_node.to_local(pos)
	return map_node.tilemap.local_to_map(localized)

func get_center_tile_pos_from_cord(coord: Vector2i) -> Vector2:
	return map_node.tilemap.map_to_local(coord)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	print(map_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
