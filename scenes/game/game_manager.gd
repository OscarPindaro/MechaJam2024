extends Node

# Spawn variables
@export var spawn_point : Marker2D
@export var goal_point : Marker2D

# Wave data
var wave_num : int = 0
var check_for_end : bool

# Status signals
signal game_start()
signal game_over()
signal wave_start(num)
signal wave_end(num)

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

	# TODO:	remove
	start_wave()

func _process(_delta):
	if check_for_end and $Spawner/Enemies.get_child_count() == 0:
		wave_end.emit(wave_num)
		check_for_end = false

func start_wave():
	wave_num += 1
	wave_start.emit(wave_num)
	print("Started wave ", wave_num)

	$Spawner.spawn_wave(wave_num, 10, 1)

func _on_start_spawning():
	pass

func _on_spawned_enemy(enemy):
	# TODO: connect to attack for health, connect to death for score
	pass

func _on_stop_spawning():
	$WaveEndTimer.start()

func _check_wave_end():
	if $Spawner/Enemies.get_child_count() == 0:
		wave_end.emit(wave_num)
		$WaveEndTimer.stop()

		# TODO: remove
		start_wave()
