class_name EnemyData
extends Resource

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

# Pathfinding
@export var pathfinding_radius : float

func _init(m_hp = 100, m_speed = 10, m_dmg = 10, m_pathfinding_radius = 10):
	start_hp = m_hp
	start_speed = m_speed
	start_dmg = m_dmg
	pathfinding_radius = m_pathfinding_radius