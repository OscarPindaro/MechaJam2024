extends BaseMecha

func do_action():
	var resource = load("res://scenes/projectiles/MopProjectile.tscn")
	var projectile = resource.instantiate() as BaseProjectile
	projectile.effect_value = damage
	shoot_projectile(projectile, targets[0])

func add_level_stats():
	damage = damage * 1.5
