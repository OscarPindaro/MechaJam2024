extends Control

@export var game_manager : GameManager
var buttons : Array[Node]

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

		# Connect buttons
		buttons = %MechaShop.get_children()
		for i in range(game_manager.mechas.size()):
			buttons[i].button_up.connect(buy_mecha.bind(i))
			buttons[i].find_child("Label", true).text = str(game_manager.mechas[i].starting_stats.cost)

		%TimeTravelButton.button_up.connect(time_travel)

func make_wave_start():
	game_manager.start_wave()
	%StartWaveButton.disabled = true

func buy_mecha(index):
	var cost = game_manager.mechas[index].starting_stats.cost
	if (game_manager.get_money() >= cost):
		game_manager.lose_money(cost)
		game_manager.mechas[index].visible = true
		buttons[index].disabled = true
		buttons[index].find_child("Panel").queue_free()

func time_travel():
	# TODO: pay later
	game_manager.time_travel.activate()
