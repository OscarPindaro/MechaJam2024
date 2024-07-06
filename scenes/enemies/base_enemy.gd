extends AnimatedSprite2D

@export var data : EnemyData

# Stats
var hp : float
var speed : float
var dmg : float
var charme : float

# Navigation
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

	# Init additional groups
	if data.additional_groups.size() > 0:
		for group in data.additional_groups:
			add_to_group(group)

	# Init sprite and collision shape
	$Area2D/CollisionShape2D.shape = data.collision_shape
	$UI.size.y = data.collision_shape.size.y
	$UI.position.y = -data.collision_shape.size.y / 2
	sprite_frames = data.animated_sprite
	frame = randi_range(0, sprite_frames.get_frame_count(animation) - 1)
	play()

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
	elif first_path_finish:
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

func on_hit(value):
	hp -= value

	$UI/HealthBar.visible = true
	$UI/HealthBar.value = (hp/data.start_hp) * 100

	$AudioStreamPlayer.stream = data.hit_sound
	$AudioStreamPlayer.play()

func on_dead():
	$AudioStreamPlayer.stream = data.death_sound
	$AudioStreamPlayer.play()

	$AudioStreamPlayer.finished.connect(queue_free)

func on_charmed():
	pass

func on_attack(_value):
	$AudioStreamPlayer.stream = data.attack_sound
	$AudioStreamPlayer.play()

	$AudioStreamPlayer.finished.connect(queue_free)
