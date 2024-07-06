extends Area2D

# state
@export var Direction: Vector2
@export var Velocity: float

# targets
@export var target_group: String = "enemies"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + (Direction * Velocity * delta)
	pass


func _on_area_entered(area):
	if area.is_in_group(target_group):
		hit_target(area)

func hit_target(area: Area2D):
	pass
