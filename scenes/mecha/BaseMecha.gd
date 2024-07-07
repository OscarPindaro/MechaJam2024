extends CharacterBody2D
class_name BaseMecha

# called at the end of a movement single step
signal finished_step()
# called at the end of a series of steps
signal finished_movement()
# singlas for hoovering and selection
signal mecha_selected(mecha: BaseMecha)
signal mecha_hoover_entered(mecha: BaseMecha)
signal mecha_hoover_exited(mecha: BaseMecha)
signal input_capture_ended()

@export var test: bool = false
@export var mov_transition: Tween.TransitionType = Tween.TRANS_QUAD
var mov_tween: Tween
@export var hoover_color: Color = Color(1,0.9,0.53, 0.5)
@export var selected_color: Color = Color(0.53,0.9,0.53, 0.5)
# status sono qua dentro
@export var starting_stats: MechaStatResource
@export var deselect_with_click: bool = false


# mecha state
var hp: float
var hp_regen: float
var speed: float # measure in seconds
var attack_speed: float:
	get:
		return attack_speed
	set(value):
		attack_speed = value
		_update_timer()
var projectile_speed: float
var damage: float
var can_shoot: bool:
	get:
		return can_shoot
	set(value):
		can_shoot = value
		if can_shoot:
			$ActionTimer.start()
		else:
			$ActionTimer.stop()
var range: float:
	get:
		return range
	set(value):
		range = value
		$VisionArea/CollisionShape2D.scale = Vector2(range, range)
		
var parent

# func state
var temp_speed: float # measure in seconds
var temp_attack_speed: float:
	get:
		return temp_attack_speed
	set(value):
		temp_attack_speed = value
		_update_timer()
var temp_damage: float
var temp_range: float


# mecha targets
@export var target_group: String = "enemy"
var selected: bool = false

var targets: Array[Node2D] = []

# object nodes
@onready var animations: AnimatedSprite2D = $Animations
@onready var walk_player: AudioStreamPlayer2D = $Sound/WalkPlayer
@onready var selection_sprite: Sprite2D = $Selection/HoverBG
var mouse_sel_area: Area2D

# utilities
var rng = RandomNumberGenerator.new()

func _ready():
	parent = get_parent()
	$VisionArea.area_entered.connect(on_vision_area_entered)
	$VisionArea.area_exited.connect(on_vision_area_exited)
	hp = starting_stats.start_hp
	hp_regen = starting_stats.start_hp_regen
	speed = starting_stats.start_speed
	attack_speed = starting_stats.start_attack_speed
	projectile_speed = starting_stats.start_projectile_speed
	damage = starting_stats.start_damage

	range = starting_stats.start_range
	print("Speed: ", speed)
	temp_speed = 0
	temp_attack_speed = 0
	temp_damage = 0
	temp_range = 0
	$TargetableArea/CollisionShape2D.transform = $CollisionShape2D.transform

	# select()
	mouse_sel_area = $MouseSelectionArea
	# connect myself to event on mouse entered and exited
	mouse_sel_area.mouse_entered.connect(on_selection_mouse_entered)
	mouse_sel_area.mouse_exited.connect(on_selection_mouse_exited)

	mouse_sel_area.input_event.connect(on_mouse_click)
	
	ready_spec()

func ready_spec():
	pass


func on_selection_mouse_entered():
	set_hoover_on_mecha(true)
	mecha_hoover_entered.emit(self)

func on_selection_mouse_exited():
	set_hoover_on_mecha(false)
	mecha_hoover_exited.emit(self)

func on_mouse_click(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			# this code selects and deselects with a click
			if deselect_with_click:
				# basically the selection is a toggle
				var was_selected: bool = selected
				set_select_mecha(!selected)
				# if it was not selected
				if was_selected == false:
					mecha_selected.emit(self)
				# if now is not selected, activate hoovering
				if selected == false:
					set_hoover_on_mecha(true)
			# this only selects, deselection will be handled by other objects
			else:
				if selected == false:
					set_select_mecha(true)
					mecha_selected.emit(self)
			print("fine input becha")	

		


func set_hoover_on_mecha(visibility: bool):
	if not selected:
		selection_sprite.visible = visibility
		selection_sprite.modulate = hoover_color

func set_select_mecha( visibility:bool):
	selection_sprite.visible = visibility
	selection_sprite.modulate = selected_color
	selected = visibility


func _input(event):
   # Mouse in viewport coordinates.
	# if test, get global position and test move_to
	if test:
		if event is InputEventMouseButton:
			var mouse_pos: Vector2 = get_global_mouse_position()
			move_to(mouse_pos)

func move_to(target_position: Vector2):
	can_shoot = false
	if mov_tween:
		mov_tween.kill()
	mov_tween = create_tween()
	if walk_player.playing == false:
		walk_player.play()
	animations.play("down")

	mov_tween.tween_property(self, "global_position", target_position, speed).set_trans(mov_transition).set_ease(Tween.EASE_OUT)
	mov_tween.tween_callback(on_mov_tween_end)


func move_along_path(target_positions: Array[Vector2]):
	# le target position sono in global space
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
		# var anim_name: String = get_mov_anim_name(curr_position, position)
		mov_tween.tween_callback(animations.play.bind(move))
		mov_tween.tween_property(self, "global_position", position, speed).set_trans(mov_transition).set_ease(Tween.EASE_OUT)
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


func select():
	pass

func on_step():
	finished_step.emit()

func on_mov_tween_end():
	walk_player.stop()
	finished_movement.emit()
	animations.stop()
	animations.play("idle")
	can_shoot = true
	

func on_vision_area_entered(area: Area2D):	
	if area.is_in_group(target_group):
		targets.append(area)
		connect_to_enemy_death(area)
		
#Controllare il funzionamento di erase e assicurarsi che tolga l'oggetto corretto
func on_vision_area_exited(area: Area2D):
	if area.is_in_group(target_group):
		targets.erase(area)


func connect_to_enemy_death(enemy: BaseEnemy):
	enemy.dead.connect(on_enemy_death.bind(enemy))

func on_enemy_death(enemy: BaseEnemy):
	if enemy in targets:
		targets.erase(enemy)



func _on_action_timer_timeout():
	$ActionTimer.start()
	if can_shoot and targets.size() != 0:
		do_action()


func do_action():
	pass
	

func shoot_projectile(projectile : BaseProjectile, target :Area2D):
	var target_position = target.global_position
	var source_position = global_position
	var direction = target_position - source_position
	var speed = projectile_speed
	
	projectile.Direction = direction
	projectile.Velocity = speed
	
	projectile.source = self
	parent.add_child(projectile)
	
#	print("PosizioneTarget: ", target_position)
#	print("PosizioneFonte: ", source_position)
#	print("Direzione: ", direction)
#	print("Velocita: ", speed)

func _update_timer():
	$ActionTimer.wait_time = 1/attack_speed
	


func buff_stat(stat:String, value: float, time: float):
	pass

func buff_attSp(value: float, time: float):
	var timer: Timer = Timer.new()
	timer.timeout.connect(end_buff_attSp)
	temp_attack_speed = value
	timer.start(time)

func end_buff_attSp():	
	temp_attack_speed = 0
	
func buff_damage(value: float, time: float):
	var timer: Timer = Timer.new()
	timer.timeout.connect(end_buff_attSp)
	temp_damage = value
	timer.start(time)

func end_buff_damage():	
	temp_damage = 0
	
	
func dummy(value):
	return true
