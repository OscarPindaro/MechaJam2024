extends Node

# Spawn variables
@export var spawn_point : Marker2D
@export var goal_point : Marker2D

# Wave data
var wave_num : int = 0

# Health data
@export var health : float = 100

# Money data
@export var money : int = 3000

# Status signals
signal game_start()
signal game_over()
signal wave_start(num)
signal wave_end(num)

signal health_change(delta, tot)
signal money_change(delta, tot)

func _ready():
	# Set spawner variables
	$Spawner.spawn_point = spawn_point
	$Spawner.goal_point = goal_point

	# Connect to spawner signals
	$Spawner.start_spawning.connect(_on_start_spawning)
	$Spawner.spawned_enemy.connect(_on_spawned_enemy)
	$Spawner.stop_spawning.connect(_on_stop_spawning)

	# Connect to end timer signal
	$WaveEndTimer.timeout.connect(_check_wave_end)

	game_start.emit()

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

func start_wave():
	wave_num += 1
	$Spawner.spawn_wave(wave_num, 10, 1) # TODO: build parameter functions
	wave_start.emit(wave_num)

func _on_start_spawning():
	pass

func _on_spawned_enemy(enemy):
	enemy.attack.connect(lose_health)
	enemy.dead.connect(gain_money)

func _on_stop_spawning():
	$WaveEndTimer.start()

func _check_wave_end():
	if $Spawner/Enemies.get_child_count() == 0:
		wave_end.emit(wave_num)
		$WaveEndTimer.stop()
