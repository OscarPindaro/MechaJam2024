extends BaseBuffProjectile

func hit_target(area: Area2D):
	var mecha = area as TargetableMechaArea
	if not mecha:
		return
	mecha.buff_damage(effect_value,buff_time)
	Velocity = 0
	end_projectile()
