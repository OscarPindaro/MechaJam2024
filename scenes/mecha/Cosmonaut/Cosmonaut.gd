extends BaseMecha

func do_action():
	var resource = load("res://scenes/projectiles/BentoProjectile.tscn")
	var projectile = resource.instantiate() as BaseProjectile
	projectile.effect_value = damage
	shoot_projectile(projectile, targets[0])

func add_level_stats():
	damage = damage * 1.2
	attack_speed = attack_speed * 1.2
	range = range * 1.2
	speed = speed * 1.2
