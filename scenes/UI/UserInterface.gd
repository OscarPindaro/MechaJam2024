extends Control

@export var game_manager : GameManager

func _ready():
	# Setup interaction with game
	if is_instance_valid(game_manager):
		# Setup wave button
		%StartWaveButton.button_up.connect(make_wave_start)
		game_manager.wave_end.connect(func(_wave) : %StartWaveButton.disabled = false)

		# Connect money and health
		game_manager.health_change.connect(%HPProgressbar._on_game_manager_health_change)

		%MoneyLabel.text = "Scrap: " + str(game_manager.get_money())
		game_manager.money_change.connect(func(_delta, tot) : %MoneyLabel.text = "Scrap: " + str(tot))

func make_wave_start():
	game_manager.start_wave()
	%StartWaveButton.disabled = true
