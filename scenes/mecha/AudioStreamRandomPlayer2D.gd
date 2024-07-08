extends AudioStreamPlayer2D
class_name AudioStreamRandomPlayer2D

@export var a: Array[AudioStream] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_random(from_position:float = 0.0):
	stream = a.pick_random()
	play(from_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
