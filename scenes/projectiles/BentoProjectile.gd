extends BaseProjectile


func hit_target(area: Area2D):
	var enemy = area as BaseEnemy
	if not enemy:
		return
	enemy.damage(effect_value)
	end_projectile()
