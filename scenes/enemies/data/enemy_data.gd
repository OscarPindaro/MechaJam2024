extends Resource
class_name EnemyData

enum SpawnCondition {
	ALWAYS,
	BEFORE_WAVE_X,
	STARTING_FROM_WAVE_X,
	EVERY_X_WAVES,
	ONLY_ON_WAVE_X
}

# Additional groups
@export var additional_groups : Array[String]

# Appearance
@export var animated_sprite : SpriteFrames
@export var collision_shape : Shape2D

# Audio
@export var hit_sound : AudioStream
@export var death_sound : AudioStream
@export var attack_sound : AudioStream

# Stats
@export var start_hp : float
@export var start_speed : float
@export var start_dmg : float
@export var money_value : float

# Pathfinding
@export var pathfinding_radius : float

# Spawn data
@export var spawn_value : float = 1
@export var spawn_frequency : float = 1
@export var spawn_condition : SpawnCondition
@export var wave_condition_value : int
var spawn_callable : Callable

func _init(m_hp = 100, m_speed = 10, m_dmg = 10, m_pathfinding_radius = 10):
	start_hp = m_hp
	start_speed = m_speed
	start_dmg = m_dmg
	pathfinding_radius = m_pathfinding_radius
	
	match spawn_condition:
		SpawnCondition.ALWAYS:
			spawn_callable = func(_wave): return true
		SpawnCondition.BEFORE_WAVE_X:
			spawn_callable = func(wave): return wave < wave_condition_value
		SpawnCondition.STARTING_FROM_WAVE_X:
			spawn_callable = func(wave): return wave >= wave_condition_value
		SpawnCondition.EVERY_X_WAVES:
			spawn_callable = func(wave): return wave / wave_condition_value == 0
		SpawnCondition.ONLY_ON_WAVE_X:
			spawn_callable = func(wave): return wave == wave_condition_value