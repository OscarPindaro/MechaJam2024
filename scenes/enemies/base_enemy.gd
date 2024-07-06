extends Area2D

const ANIMATION_NAMES : Array[String] = ["move", "death", "attack"]

@export var data : EnemyData

# Stats
var hp : float
var speed : float
var dmg : float
var charme : float

# Navigation
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
	if data.additional_groups.size() > 0:
		for group in data.additional_groups:
			add_to_group(group)

	# Init sprite and collision shape
	$AreaShape.shape = data.collision_shape
	$AnimatedSprite.sprite_frames = data.animated_sprite
	$AnimatedSprite.animation = ANIMATION_NAMES[0]
	$AnimatedSprite.frame = randi_range(0, $AnimatedSprite.sprite_frames.get_frame_count(ANIMATION_NAMES[0]) - 1)
	$AnimatedSprite.play()

	# Init health bar shape
	$UI.size = data.collision_shape.size
	$UI.position = -data.collision_shape.size / 2

	# Init stats
	hp = data.start_hp
	speed = data.start_speed
	dmg = data.start_dmg

	# Add binding to signals
	hit.connect(on_hit)
	dead.connect(on_dead)
	charmed.connect(on_charmed)
	attack.connect(on_attack)

func _process(delta):
	# Move towards target
	if !$NavigationAgent2D.is_navigation_finished():
		var next_path_pos = $NavigationAgent2D.get_next_path_position()
		
		# Randomize target position to add visual interest
		if next_path_pos != current_path_position:
			current_path_position = next_path_pos
			current_target = next_path_pos + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * data.pathfinding_radius
		
		# Move with speed
		position += (current_target - position).normalized() * speed * delta
	elif first_path_finish && $NavigationAgent2D.target_position == goal_position:
		emit_signal("attack", dmg)
		first_path_finish = false

func damage(value):
	emit_signal("hit", value)
	if hp <= 0:
		emit_signal("dead")

func apply_charme(value):
	charme += value
	if charme >= hp:
		emit_signal("charmed")

func set_goal(target):
	goal_position = target
	$NavigationAgent2D.target_position = target

func change_target(target):
	$NavigationAgent2D.target_position = target

func change_speed(value):
	speed = value

func multiply_speed(multiplier):
	speed *= multiplier

func push_to_start(speed_multiplier, time):
	# Push back towards start and change position
	change_target(starting_position)
	multiply_speed(speed_multiplier)

	$Timer.wait_time = time
	$Timer.start()
	$Timer.timeout.connect(change_target.bind(goal_position))
	$Timer.timeout.connect(change_speed.bind(data.start_speed))

func on_hit(value):
	hp -= value
	print(hp)

	$UI/HealthBar.visible = true
	$UI/HealthBar.value = (hp/data.start_hp) * 100

	$AudioStreamPlayer.stream = data.hit_sound
	$AudioStreamPlayer.play()

func on_dead():
	$AnimatedSprite.animation = ANIMATION_NAMES[1]

	$AudioStreamPlayer.stream = data.death_sound
	$AudioStreamPlayer.play()

	$AudioStreamPlayer.finished.connect(queue_free)

func on_charmed():
	pass

func on_attack(_value):
	$AnimatedSprite.animation = ANIMATION_NAMES[2]

	$AudioStreamPlayer.stream = data.attack_sound
	$AudioStreamPlayer.play()

	$AudioStreamPlayer.finished.connect(queue_free)
