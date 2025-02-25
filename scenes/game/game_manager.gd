extends Node
class_name GameManager

# Spawn variables
@export var spawn_point : Marker2D
@export var goal_point : Marker2D

# Wave data
@export var start_spawn_value : float = 100
@export var start_spawn_timer : float = 1
@export var spawn_value_percentage_increase : float = 0.05
@export var spawn_timer_percentage_reduce : float = 0.05
var spawn_value : float
var spawn_timer : float
var wave_num : int = 0
var wave_in_progress : bool = false

var pay_time_travel_wave : int = 0
var time_travel_needs_paying : bool = false

# Game data
@export var health : float = 100
@export var money : int = 3000
var is_game_over : bool = false

# Mecha references
@export var mechas : Array[BaseMecha]

@export var time_traveler : Node2D
@export var time_travel_cost : int = 1000

# Status signals
signal game_start()
signal game_over()
signal wave_start(num)
signal wave_end(num)
signal paid_time_travel()

signal health_change(delta, tot)
signal money_change(delta, tot)

func _ready():
	# Set spawner variables
	$Spawner.spawn_point = spawn_point
	$Spawner.goal_point = goal_point

	spawn_value = start_spawn_value
	spawn_timer = start_spawn_timer

	# Connect to spawner signals
	$Spawner.start_spawning.connect(_on_start_spawning)
	$Spawner.spawned_enemy.connect(_on_spawned_enemy)
	$Spawner.stop_spawning.connect(_on_stop_spawning)

	# Connect to end timer signal
	$WaveEndTimer.timeout.connect(_check_wave_end)

	time_travel_cost = time_traveler.starting_stats.cost
	time_traveler.start_time_travelling.connect(func() : %AudioStreamPlayer.stream_paused = true)
	time_traveler.end_time_travelling.connect(func() : %AudioStreamPlayer.stream_paused = false)

	game_start.emit()
	wave_end.connect(on_wave_end)
	get_tree().paused = false

func get_wave_num():
	return wave_num

func get_money():
	return money

func get_health():
	return health

func gain_money(value):
	money += value
	money_change.emit(value, money)

func lose_money(value):
	money -= value
	money_change.emit(-value, money)

func lose_health(value):
	health -= value
	health_change.emit(value, health)
	if health <= 0:
		game_over.emit()
		is_game_over = true

func start_wave():
	if !wave_in_progress && !is_game_over:
		wave_in_progress = true
		wave_num += 1

		if wave_num != 1:	# Update difficulty
			spawn_value = roundi(spawn_value * (1 + spawn_value_percentage_increase))
			spawn_timer = roundf(spawn_timer * (1 - spawn_timer_percentage_reduce) * 100) / 100

		$Spawner.spawn_wave(wave_num, spawn_value, spawn_timer)
		wave_start.emit(wave_num)
		print("Started wave ", wave_num, " with params: ", spawn_value, " ", spawn_timer)

func time_travel():
	time_traveler.activate()
	pay_time_travel_wave = wave_num + 2
	time_travel_needs_paying = true

	

func _check_wave_end():
	if $Spawner/Enemies.get_child_count() == 0:
		wave_in_progress = false
		wave_end.emit(wave_num)
		$WaveEndTimer.stop()

func _on_start_spawning():
	pass

func _on_spawned_enemy(enemy):
	enemy.attack.connect(lose_health)
	enemy.dead.connect(gain_money)

func _on_stop_spawning():
	$WaveEndTimer.start()

func on_wave_end(num):
	if num == pay_time_travel_wave:	# If you should pay time traveler, do it
		lose_money(time_travel_cost)
		if money < 0:
			game_over.emit()
		else:
			time_travel_needs_paying = false
			paid_time_travel.emit()
