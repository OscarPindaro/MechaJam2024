extends BaseMecha

func do_action():
	if targets.size() == 0:
		return
	var resource = load("res://scenes/projectiles/MopProjectile.tscn")
	var projectile = resource.instantiate() as BaseProjectile
	projectile.effect_value = damage
	shoot_projectile(projectile, targets[0])
