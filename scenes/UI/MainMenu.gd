extends Control

var counter = 0
var goal = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Glare.visible = !$Glare.visible
	goal = randi_range(10,100)
	$StartMusicTimer.timeout.connect(start_music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counter >= goal:
		$Glare.visible = !$Glare.visible
		goal = randi_range(10,100)
		counter = 0
	else:
		counter += 1
		
func start_music():
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
