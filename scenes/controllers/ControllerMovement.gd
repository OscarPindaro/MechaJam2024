extends Node
class_name ControllerMovement

@export var cell_size: Vector2i = Vector2i(64,64)
@export var region: Rect2i = Rect2i(0,0,11,18)

var a_star: AStarGrid2D
var setupDone : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(cell_size != null, "cell_size can not be None")
	assert(region != null, "region can not be None")


func setup_astar():
	a_star = AStarGrid2D.new()
	a_star.region = region
	a_star.diagonal_mode = 1
	a_star.default_compute_heuristic = 1
	a_star.default_estimate_heuristic = 1

	a_star.update()

	# Disable non-walkable cells
	for i in range(region.size.x):
		for j in range(region.size.y):
			var cell = Vector2i(i, j)
			if !get_parent().is_cell_walkable(cell):
				a_star.set_point_solid(cell, true)
				print(cell)

	setupDone = true

func compute_id_path(start: Vector2i, end: Vector2i)-> Array[Vector2i]:
	if !setupDone: setup_astar()
	return a_star.get_id_path(start, end)

func compute_point_path(start: Vector2i, end: Vector2i)-> Array[Vector2]:
	if !setupDone: setup_astar()
	return a_star.get_point_path(start, end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
