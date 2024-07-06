extends Node
class_name ControllerMovement

# @export var map_path: NodePath
# @onready var map: Map = get_node(map_path)
@export var cell_size: Vector2i = Vector2i(64,64)
@export var region: Rect2i = Rect2i(0,0,11,18)

var a_star: AStarGrid2D 



# Called when the node enters the scene tree for the first time.
func _ready():
	# assert(map != null, "Map can not be None")
	assert(cell_size != null, "cell_size can not be None")
	assert(region != null, "region can not be None")
	setup_astar()


func setup_astar():
	a_star = AStarGrid2D.new()
	a_star.region = region
	a_star.diagonal_mode = 1
	a_star.default_compute_heuristic = 1
	a_star.default_estimate_heuristic = 1
	a_star.update()

func compute_id_path(start: Vector2i, end: Vector2i)-> Array[Vector2i]:
	return a_star.get_id_path(start, end)

func compute_point_path(start: Vector2i, end: Vector2i)-> Array[Vector2]:
	return a_star.get_point_path(start, end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
