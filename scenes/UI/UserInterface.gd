extends Control

@export var game_manager : GameManager

func _ready():
	# Setup interaction with game
	if is_instance_valid(game_manager):
		# Setup wave button
		%StartWaveButton.button_up.connect(make_wave_start)
		game_manager.wave_end.connect(func(_wave) : %StartWaveButton.disabled = false )

func make_wave_start():
	game_manager.start_wave()
	%StartWaveButton.disabled = true