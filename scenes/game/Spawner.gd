extends Node

@export var base_enemy : PackedScene
@export var enemy_types : Array[EnemyData]
@export var spawn_radius : float

var spawn_point : Marker2D
var goal_point : Marker2D

var wave_num = 0
var possible_enemies_frequency = 0
var spawned_enemy_value : int = 0
var tot_enemy_value : float

signal start_spawning()
signal spawned_enemy(enemy)
signal stop_spawning()

func _ready():
	# Init randomizer
	randomize()

func can_spawn(enemy):
	match enemy.spawn_condition:
		0: # ALWAYS
			return true
		1: # BEFORE_WAVE_X
			return wave_num < enemy.wave_condition_value
		2: # STARTING_FROM_WAVE
			return wave_num >= enemy.wave_condition_value
		3: # EVERY_X_WAVES
			return wave_num % enemy.wave_condition_value == 0
		4: # ONLY_ON_WAVE_X
			return wave_num == enemy.wave_condition_value

func spawn_wave(new_wave_num, new_tot_enemy_value, time_between_spawns):
	# Reset variables
	wave_num = new_wave_num
	tot_enemy_value = new_tot_enemy_value
	spawned_enemy_value = 0
	
	# Set total frequency for possible enemies
	possible_enemies_frequency = 0
	for enemy in enemy_types:
		print(enemy.resource_name, " ", can_spawn(enemy))
		if can_spawn(enemy):
			possible_enemies_frequency += enemy.spawn_frequency
	
	# Start spawn cycle
	$SpawnTimer.wait_time = time_between_spawns
	$SpawnTimer.timeout.connect(spawn_cycle)
	$SpawnTimer.start()

	start_spawning.emit()

func spawn_cycle():
	# Spawn until you've spawned enemies up to the total value
	if spawned_enemy_value < tot_enemy_value:
		spawn_random_enemy()
	else:
		$SpawnTimer.timeout.disconnect(spawn_cycle)
		$SpawnTimer.stop()

		stop_spawning.emit()

func spawn_random_enemy():
	# Extract at random an enemy to spawn based on frequency
	var random = randf_range(0, possible_enemies_frequency)
	var current = 0
	for enemy in enemy_types:
		if can_spawn(enemy):
			current += enemy.spawn_frequency
			if current >= random:
				spawn_enemy(enemy, spawn_point.position, spawn_radius)
				return

func spawn_enemy(enemy_data, pos, radius):
	# Add the enemy value to the total spawn value
	spawned_enemy_value += enemy_data.spawn_value

	# Create the new enemy and place it
	var new_enemy = base_enemy.instantiate()
	new_enemy.stats = enemy_data
	new_enemy.spawner = self
	new_enemy.position = pos + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * radius
	new_enemy.set_goal(goal_point.position)
	$Enemies.add_child(new_enemy)

	# Signal that you spawned an enemy
	spawned_enemy.emit(new_enemy)
