extends HSlider

func _ready():
	# NON FUNZIONA
	var initial_value = db_to_linear(AudioServer.get_bus_volume_db(self.get_meta('volume_controller')))
	self.value = initial_value
	print(AudioServer.get_bus_name(self.get_meta('volume_controller')))
	print(initial_value)
	print(AudioServer.get_bus_volume_db(self.get_meta('volume_controller')))


func _on_value_changed(value):
	AudioServer.set_bus_volume_db(self.get_meta('volume_controller'),linear_to_db(value))
