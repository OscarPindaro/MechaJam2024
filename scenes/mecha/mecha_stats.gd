extends Resource
class_name MechaStatResource

@export var start_hp: float = 100
@export var start_hp_regen: float = 1
@export var start_speed: float = 1
@export var start_attack_speed: float = 1
@export var start_projectile_speed: float = 10
@export var start_damage: float = 10
@export var start_range: float = 10

@export var cost : int = 100
@export var lvlCost : int = 50
@export var lvlUp : LvlUpBehaviour
@export var tooltipName : String
@export var tooltipDescription : String
