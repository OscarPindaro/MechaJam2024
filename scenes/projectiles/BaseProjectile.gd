extends Area2D
class_name BaseProjectile

# state
@export var Direction: Vector2
@export var Velocity: float

# targets
@export var target_group: String = "enemy"

# effect
@export var effect_value: float

# sounds
@export var end_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	$EndStreamPlayer.stream = end_sound
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

func end_projectile():
	$EndStreamPlayer.play()
	

func _on_end_stream_player_finished():
	queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	end_projectile()
	pass # Replace with function body.
