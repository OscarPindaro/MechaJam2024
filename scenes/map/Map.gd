extends Node2D
class_name Map

@onready var tilemap: TileMap = $TileMap

const CARDBOARD_LAYER = 1

func is_cell_cardboard(cell: Vector2i) -> bool:
	var id: int =tilemap.get_cell_source_id(CARDBOARD_LAYER, cell)
	# if == -1, no cardboard present
	if id == -1:
		return false
	else:
		return true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
