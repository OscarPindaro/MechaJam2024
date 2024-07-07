extends Area2D
class_name BaseEnemy

const ANIMATION_NAMES : Array[String] = ["move_hor", "move_vert", "death", "attack"]

var stats : EnemyData
var spawner : Node

# Stats
var hp : float
var speed : float
var dmg : float
var charme : float
var money_value : float

# Navigation
var can_move : bool = true
var starting_position : Vector2
var goal_position : Vector2
var current_path_position : Vector2
var current_target : Vector2
var first_path_finish : bool = true

# Status
var is_charmed : bool = false

# Signals
signal hit(dmg)
signal dead(money_value)
signal hit_charme(value)
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
	$UI.set_deferred("size", Vector2(stats.collision_shape.size.x/2, stats.collision_shape.size.y))
	$UI.set_deferred("position", -stats.collision_shape.size / 2)

	# Init stats
	hp = stats.start_hp
	speed = stats.start_speed
	dmg = stats.start_dmg

	# Set minion spawn if necessary
	if stats.minion_spawn == 1:	# ON_DEATH
		dead.connect(func(_value): call_deferred("spawn_minions"))
	elif stats.minion_spawn == 2: # AT_INTERVALS
		var minion_timer = Timer.new()
		add_child(minion_timer)
		minion_timer.wait_time = stats.minion_deltatime
		minion_timer.timeout.connect(spawn_minions)
		minion_timer.start()

	# Add binding to signals
	hit.connect(on_hit)
	dead.connect(on_dead)
	hit_charme.connect(on_hit_charme)
	charmed.connect(on_charmed)
	attack.connect(on_attack)
	area_entered.connect(on_area_entered)

func _physics_process(delta):
	# Move towards target
	if !$NavigationAgent2D.is_navigation_finished() && can_move:
		var next_path_pos = $NavigationAgent2D.get_next_path_position()
		
		# Randomize target position to add visual interest
		if next_path_pos != current_path_position:
			current_path_position = next_path_pos
			current_target = next_path_pos + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * stats.pathfinding_radius
		
		# Move with speed
		var direction = (current_target - position).normalized()
		position += direction * speed * delta
		
		# Update animation based on direction
		if direction.x >= 0.5:
			$AnimatedSprite.animation = ANIMATION_NAMES[0]
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = false
		elif direction.x < -0.5:
			$AnimatedSprite.animation = ANIMATION_NAMES[0]
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.flip_v = false
		elif direction.y <= -0.5 && $AnimatedSprite.sprite_frames.has_animation(ANIMATION_NAMES[1]):
			$AnimatedSprite.animation = ANIMATION_NAMES[1]
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = false
		elif $AnimatedSprite.sprite_frames.has_animation(ANIMATION_NAMES[1]):
			$AnimatedSprite.animation = ANIMATION_NAMES[1]
			$AnimatedSprite.flip_v = true
			$AnimatedSprite.flip_h = false

	elif can_move && first_path_finish && !is_charmed && $NavigationAgent2D.target_position == goal_position:	# When got to goal attack
		first_path_finish = false
		attack.emit(dmg)
	elif can_move && is_charmed && $NavigationAgent2D.target_position == starting_position: # When charmed and got to start
		queue_free()

func damage(value):
	hp -= value
	hit.emit(value)
	if hp <= 0:
		dead.emit(stats.money_value)

func apply_charme(value):
	charme += value
	hit_charme.emit(value)
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

func spawn_minions():
	if is_instance_valid(stats.minion_spawn_sound):
		$AudioStreamPlayer.stream = stats.minion_spawn_sound
		$AudioStreamPlayer.play()

	for n in range(stats.minion_number):
		var i = randi_range(0, stats.minion_types.size() - 1)
		spawner.spawn_enemy(stats.minion_types[i], position, stats.minion_radius)

func on_hit(value):
	$UI.visible = true
	$UI/HealthBar.value = (hp/stats.start_hp) * 100
	if is_charmed:
		$UI/CharmeBar.value = (hp/stats.start_hp) * 100

	if is_instance_valid(stats.hit_sound):
		$AudioStreamPlayer.stream = stats.hit_sound
		$AudioStreamPlayer.play()

func on_dead(_money_value):
	can_move = false
	$UI.visible = false
	$AnimatedSprite.animation = ANIMATION_NAMES[2]

	if is_instance_valid(stats.death_sound):
		$AudioStreamPlayer.stream = stats.death_sound
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.finished.connect(queue_free)
	else:
		$AnimatedSprite.animation_finished.connect(queue_free)

func on_hit_charme(value):
	$UI.visible = true
	$UI/CharmeBar.value = (charme/stats.start_hp) * 100

func on_charmed():
	is_charmed = true
	change_target(starting_position)


func on_attack(_value):
	can_move = false
	$AnimatedSprite.animation = ANIMATION_NAMES[3]

	if is_instance_valid(stats.attack_sound):
		$AudioStreamPlayer.stream = stats.attack_sound
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.finished.connect(queue_free)
	else:
		$AnimatedSprite.animation_finished.connect(queue_free)

func on_area_entered(area:Area2D):
	if area.is_in_group("enemy"):
		if area.is_charmed != is_charmed:	# If the charm status is different, hit it
			area.damage(dmg)
