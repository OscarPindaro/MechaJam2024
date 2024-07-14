extends Node2D
class_name Map

@onready var tilemap: TileMap = $TileMap

const CARDBOARD_LAYER = 1
const NON_WALKABLE_LAYER = 2

const CORRECT_TILE_ID = 2
const WRONG_TILE_ID = 3
const SELECTION_LAYER = 3

var old_selection_cell 	= null

func is_cell_cardboard(cell: Vector2i) -> bool:
	var id: int =tilemap.get_cell_source_id(CARDBOARD_LAYER, cell)
	# if == -1, no cardboard present
	if id == -1:
		return false
	else:
		return true

func is_cell_walkable(cell: Vector2i) -> bool:
	var id: int = tilemap.get_cell_source_id(NON_WALKABLE_LAYER, cell)
	if id == -1:	# Not found, so its walkable
		return true
	else:
		return false

func draw_selection(cell: Vector2i, is_valid: bool):
	# cancel old selection
	if old_selection_cell != null:
		# clears the old selection
		# tilemap.set_cell(SELECTION_LAYER, cell, -1, Vector2i(-1,-1), -1)
		tilemap.erase_cell(SELECTION_LAYER, old_selection_cell)
	
	var id_to_draw: int = CORRECT_TILE_ID if is_valid else WRONG_TILE_ID
	tilemap.set_cell(SELECTION_LAYER, cell, id_to_draw, Vector2i(0,0), 0)
	old_selection_cell = cell


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
