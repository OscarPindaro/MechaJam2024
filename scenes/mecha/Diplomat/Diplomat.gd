extends BaseMecha


func do_action():
	for enemy in targets:
		var enemy_casted = enemy as BaseEnemy
		enemy_casted.charm(damage)
