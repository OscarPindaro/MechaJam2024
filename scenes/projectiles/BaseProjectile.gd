extends Area2D
class_name BaseProjectile

# state
@export var Direction: Vector2:
	get:
		return Direction
	set(value):
		Direction = value
		spec_rotate()
		
@export var Velocity: float
var ending: bool = false
var source: BaseMecha

# targets
@export var target_group: String = "enemy"

# effect
@export var effect_value: float

# sounds
@export var shoot_sound: AudioStream
@export var end_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootStreamPlayer.stream = shoot_sound
	$EndStreamPlayer.stream = end_sound
	ready_spec()

func ready_spec():
	pass
	

func spec_rotate():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + (Direction * Velocity * delta)
	#print("Posizione: ", position)
	pass


func _on_area_entered(area):
	print(source)
	if area.is_in_group(target_group) and not source.is_ancestor_of(area):
		if not ending:
			hit_target(area)

func hit_target(area: Area2D):
	pass

func end_projectile():
	ending = true
	$EndStreamPlayer.play()
	

func _on_end_stream_player_finished():
	queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	end_projectile()
	pass # Replace with function body.
