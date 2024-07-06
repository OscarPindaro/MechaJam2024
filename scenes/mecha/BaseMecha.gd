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
var speed: float # measure in seconds
var attack_speed: float
var damage: float
var can_shoot: bool = true

var targets: Array[Node2D] = []

# object nodes
@onready var animations: AnimatedSprite2D = $Animations
@onready var walk_player: AudioStreamPlayer2D = $Sound/WalkPlayer

func _ready():
	hp = starting_stats.start_hp
	hp_regen = starting_stats.start_hp_regen
	speed = starting_stats.start_speed
	attack_speed = starting_stats.start_attack_speed
	damage = starting_stats.start_damage
	print("Speed: ", speed)


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
	animations.play("down")

	mov_tween.tween_property(self, "position", target_position, speed).set_trans(mov_transition).set_ease(Tween.EASE_OUT)
	mov_tween.tween_callback(on_mov_tween_end)


func move_along_path(target_positions: Array[Vector2]):
	# tween along e path of positions
	if mov_tween:
		mov_tween.kill()
	mov_tween = create_tween()
	# the whole animation lasts in long and short paths

	# start animating? 

	var curr_position: Vector2 = position
	mov_tween.tween_callback(walk_player.play)
	for position in target_positions:
		# compute direction and decide which animation to play
		var anim_name: String = get_mov_anim_name(curr_position, position)
		mov_tween.tween_callback(animations.play.bind(anim_name))
		mov_tween.tween_property(self, "position", position, speed).set_trans(mov_transition).set_ease(Tween.EASE_OUT)
		mov_tween.tween_callback(on_step)
		# reset current position
		curr_position = position
	# when movement stops, emit stop signal
	mov_tween.tween_callback(on_mov_tween_end)


func get_mov_anim_name(start: Vector2, end: Vector2) -> String:
	# moving right
	if end.x > start.x:
		return "move_right"
	# move left
	elif end.x < start.x:
		return "move_left"
	# move down
	elif end.y > start.y:
		return "move_down"
	else:
		return "move_up"

func _physics_process(delta):
	pass

func on_step():
	finished_step.emit()

func on_mov_tween_end():
	walk_player.stop()
	finisched_movement.emit()
	animations.stop()
	animations.play("default")
