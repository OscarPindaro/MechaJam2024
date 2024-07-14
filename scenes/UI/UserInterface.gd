extends Control

var countdown = 0
@export var game_manager: GameManager
var buttons : Array[Node]

func _ready():
	# Setup interaction with game
	if is_instance_valid(game_manager):
		# Setup wave button
		%StartWaveButton.pressed_unpaused.connect(make_wave_start)
		game_manager.wave_end.connect(func(_wave) : %StartWaveButton.disabled = false)

		# Connect money and health
		game_manager.health_change.connect(%HPProgressbar._on_game_manager_health_change)

		%MoneyLabel.text = "Scrap: " + str(game_manager.get_money())
		game_manager.money_change.connect(func(_delta, tot) : %MoneyLabel.text = "Scrap: " + str(tot))

		# Connect buttons
		buttons = %MechaShop.get_children()
		for i in range(game_manager.mechas.size()):
			buttons[i].pressed_unpaused.connect(buy_mecha.bind(i))
			buttons[i].mechaData = game_manager.mechas[i].starting_stats
			buttons[i].find_child("Label", true).text = str(game_manager.mechas[i].starting_stats.cost)
			game_manager.money_change.connect(buttons[i]._on_money_change)
			buttons[i]._on_money_change(0, game_manager.get_money())

		%TimeTravelButton.disabled = true
		game_manager.wave_start.connect(func(_num) : %TimeTravelButton.disabled = game_manager.time_travel_needs_paying)
		game_manager.wave_end.connect(func(_num): %TimeTravelButton.disabled = true)
		%TimeTravelButton.pressed_unpaused.connect(time_travel)
		game_manager.paid_time_travel.connect(restore_time_travel)
		%TimeTravelButton.mechaData = game_manager.time_traveler.starting_stats

		# Connect wave num
		%WaveLabel.text = "Wave: 0"
		game_manager.wave_start.connect(func(num): %WaveLabel.text = "Wave: " + str(num))

		# Connect wave end panel
		game_manager.wave_end.connect(%EndWaveLayer.fade_in_out)

func make_wave_start():
	game_manager.start_wave()
	%StartWaveButton.disabled = true

func buy_mecha(index):
	var button = buttons[index]
	var mecha = game_manager.mechas[index]
	var cost = mecha.cost
	if (game_manager.get_money() >= cost):
		buttons[index].bought = true
		game_manager.lose_money(cost)
		mecha.buy()
		cost = mecha.cost
		button.find_child("Label", true).text = str(cost)
		button.find_child("LvlUpArrow", true).visible = true
		button.mechaData.cost = cost
#		buttons[index].disabled = true
#		buttons[index].find_child("Panel").queue_free()

func time_travel():
	game_manager.time_travel()
	%TimeTravelButton.disabled = true
	%TimeTravelButton.find_child("Label").text = "Pay " + str(game_manager.time_travel_cost) + "\nat end of\nwave " + str(game_manager.pay_time_travel_wave)

func restore_time_travel():
	%TimeTravelButton.disabled = false
	%TimeTravelButton.find_child("Label").text = "Buy now\nPay\nLater"
