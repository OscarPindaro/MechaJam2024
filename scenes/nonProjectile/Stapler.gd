extends AnimatedSprite2D
class_name Stapler

#stats
@export var damage :float

#target
@export var target :BaseEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func attack():
	$StartAudioPlayer.play()
	target.change_speed(0)
	position = target.position
	play()

func _on_animation_finished():
	$EndAudioPlayer.play()
	if is_instance_valid(target):
		target.reset_speed()
	if is_instance_valid(target):
		target.damage(damage)
	


func _on_end_audio_player_finished():
	queue_free()
