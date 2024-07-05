extends CharacterBody2D
class_name BaseMecha

# called at the end of a movement single step
signal finished_step()
# called at the end of a series of steps
signal finisched_movement()

@export var test: bool = false

@export var mov_transition: Tween.TransitionType = Tween.TRANS_QUAD
var mov_tween: Tween

# status sono qua dentro
@export var starting_stats: MechaStatResource

# mecha state
var hp: float
var hp_regen: float
var speed: float
var attack_speed: float
var damage: float
var can_shoot: bool = true

var targets: Array[Node2D] = []

# object nodes
@onready var walk_player: AudioStreamPlayer2D = $Sound/WalkPlayer

func _ready():
	hp = starting_stats.start_hp
	hp_regen = starting_stats.start_hp_regen
	speed = starting_stats.start_speed
	attack_speed = starting_stats.start_attack_speed
	damage = starting_stats.start_damage


func _input(event):
   # Mouse in viewport coordinates.
	# if test, get global position and test move_to
	if test:
		if event is InputEventMouseButton:
			var mouse_pos: Vector2 = get_global_mouse_position()
			move_to(mouse_pos)

func move_to(target_position: Vector2):
	if mov_tween:
		mov_tween.kill()
	mov_tween = create_tween()
	if walk_player.playing == false:
		walk_player.play()
	mov_tween.tween_property(self, "position", target_position, speed).set_trans(mov_transition).set_ease(Tween.EASE_OUT)
	mov_tween.tween_callback(on_mov_tween_end)


func _physics_process(delta):
	pass

func on_mov_tween_end():
	walk_player.stop()
	finished_step.emit()