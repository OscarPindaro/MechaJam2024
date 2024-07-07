extends BaseProjectile

func spec_rotate():
	rotation = Direction.angle()
	pass


func hit_target(area: Area2D):
	var enemy = area as BaseEnemy
	if not enemy:
		return
	enemy.damage(effect_value)
