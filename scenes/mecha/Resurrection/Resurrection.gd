extends BaseMecha

@export var buff_time_scaler:float


func do_action():
	if targets.size() == 0:
		return
	var resource 
	var prj_type = rng.randi_range ( 0, 1 )
	if prj_type == 0:
		resource = load("res://scenes/projectiles/CoffeeProjectile.tscn")
	else:
		resource = load("res://scenes/projectiles/DoughnutProjectile.tscn")	
	var projectile = resource.new() as BaseBuffProjectile
	projectile.buff_time = damage * buff_time_scaler
	projectile.effect_value = damage
	
	var trg_num = rng.randi_range(0, targets.size() - 1)
	
	shoot_projectile(projectile, targets[trg_num])

