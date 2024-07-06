extends Area2D

const ANIMATION_NAMES : Array[String] = ["move", "death", "attack"]

var stats : EnemyData

# Stats
var hp : float
var speed : float
var dmg : float
var charme : float

# Navigation
var can_move : bool = true
var starting_position : Vector2
var goal_position : Vector2
var current_path_position : Vector2
var current_target : Vector2
var first_path_finish : bool = true

# Signals
signal hit(dmg)
signal dead()
signal charmed()
signal attack(dmg)

func _ready():
	# Init randomizer
	randomize()

	# Save starting position
	starting_position = position

	# Init additional groups
	if stats.additional_groups.size() > 0:
		for group in stats.additional_groups:
			add_to_group(group)

	# Init sprite and collision shape
	$AreaShape.shape = stats.collision_shape
	$AnimatedSprite.sprite_frames = stats.animated_sprite
	$AnimatedSprite.animation = ANIMATION_NAMES[0]
	$AnimatedSprite.frame = randi_range(0, $AnimatedSprite.sprite_frames.get_frame_count(ANIMATION_NAMES[0]) - 1)
	$AnimatedSprite.play()

	# Init health bar shape
	$UI.set_deferred("size", stats.collision_shape.size)
	$UI.set_deferred("position", -stats.collision_shape.size / 2)

	# Init stats
	hp = stats.start_hp
	speed = stats.start_speed
	dmg = stats.start_dmg

	# Add binding to signals
	hit.connect(on_hit)
	dead.connect(on_dead)
	charmed.connect(on_charmed)
	attack.connect(on_attack)

func _physics_process(delta):
	# Move towards target
	if !$NavigationAgent2D.is_navigation_finished() && can_move:
		var next_path_pos = $NavigationAgent2D.get_next_path_position()
		
		# Randomize target position to add visual interest
		if next_path_pos != current_path_position:
			current_path_position = next_path_pos
			current_target = next_path_pos + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * stats.pathfinding_radius
		
		# Move with speed
		position += (current_target - position).normalized() * speed * delta
	elif first_path_finish && $NavigationAgent2D.target_position == goal_position:
		attack.emit(dmg)
		first_path_finish = false

func damage(value):
	hit.emit(value)
	if hp <= 0:
		dead.emit()

func apply_charme(value):
	charme += value
	if charme >= hp:
		charmed.emit()

func set_goal(target):
	goal_position = target
	$NavigationAgent2D.target_position = target

func change_target(target):
	$NavigationAgent2D.target_position = target

func change_speed(value):
	speed = value

func multiply_speed(multiplier):
	speed *= multiplier

func reset_speed():
	speed = stats.start_speed

func push_to_start(speed_multiplier, time):
	# Push back towards start and change position
	change_target(starting_position)
	multiply_speed(speed_multiplier)

	$Timer.wait_time = time
	$Timer.timeout.connect(timer_reset_after_push)
	$Timer.start()

func timer_reset_after_push():
	change_target(goal_position)
	reset_speed()
	$Timer.timeout.disconnect(timer_reset_after_push)

func on_hit(value):
	hp -= value

	$UI/HealthBar.visible = true
	$UI/HealthBar.value = (hp/stats.start_hp) * 100

	if is_instance_valid(stats.hit_sound):
		$AudioStreamPlayer.stream = stats.hit_sound
		$AudioStreamPlayer.play()

func on_dead():
	can_move = false
	$UI/HealthBar.visible = false
	$AnimatedSprite.animation = ANIMATION_NAMES[1]

	if is_instance_valid(stats.death_sound):
		$AudioStreamPlayer.stream = stats.death_sound
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.finished.connect(queue_free)
	else:
		queue_free()

func on_charmed():
	pass

func on_attack(_value):
	can_move = false
	$AnimatedSprite.animation = ANIMATION_NAMES[2]

	if is_instance_valid(stats.attack_sound):
		$AudioStreamPlayer.stream = stats.attack_sound
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.finished.connect(queue_free)
	else:
		queue_free()
