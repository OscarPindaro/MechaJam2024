extends Control

var countdown = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.countdown = self.countdown + 1
	
	if self.countdown == 60:
		%HPProgressbar.change_health(10)
		self.countdown = 0
	

