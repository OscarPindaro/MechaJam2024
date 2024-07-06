extends BaseBuffProjectile


func hit_target(area: Area2D):
	var mecha = area as TargetableMechaArea
	if not mecha:
		return
	mecha.buff_attSp(effect_value,buff_time)
	end_projectile()
