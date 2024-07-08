extends Resource
class_name EnemyData

enum SpawnCondition {
	ALWAYS,
	BEFORE_WAVE_X,
	STARTING_FROM_WAVE_X,
	EVERY_X_WAVES,
	ONLY_ON_WAVE_X
}

enum MinionSpawn {
	NO,
	ON_DEATH,
	AT_INTERVALS
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
var pathfinding_radius : float = 10

# Spawn data
@export var spawn_value : float = 1
@export var spawn_frequency : float = 1
@export var spawn_condition : SpawnCondition
@export var wave_condition_value : int

# Custom data
@export var minion_spawn : MinionSpawn
@export var minion_types : Array[EnemyData]
@export var minion_number : int = 5
@export var minion_deltatime : float = 5
@export var minion_radius : float = 10
@export var minion_spawn_sound : AudioStream

func _init(m_hp = 100, m_speed = 10, m_dmg = 10, m_pathfinding_radius = 10):
	start_hp = m_hp
	start_speed = m_speed
	start_dmg = m_dmg
	pathfinding_radius = m_pathfinding_radius
