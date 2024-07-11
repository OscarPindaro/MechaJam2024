extends BaseMecha


func do_action():
	for enemy in targets:
		var enemy_casted = enemy as BaseEnemy
		enemy_casted.apply_charme(damage/2)

func add_level_stats():
	attack_speed = attack_speed * 1.5
