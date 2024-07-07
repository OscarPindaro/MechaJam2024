extends BaseProjectile

func ready_spec():
	$AnimatedSprite2D.frame = randi_range(0, $AnimatedSprite2D.sprite_frames.get_frame_count("default") - 1)

func hit_target(area: Area2D):
	var enemy = area as BaseEnemy
	if not enemy:
		return
	enemy.damage(effect_value)
	Velocity = 0
	end_projectile()	
