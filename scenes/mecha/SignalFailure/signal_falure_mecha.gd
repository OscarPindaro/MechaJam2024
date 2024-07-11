extends BaseMecha
class_name SignalFailureMecha


@export_range(0,0.9, 0.1) var perc: float = 0.3

var enemies_affected: Array[BaseEnemy] = []

func do_action():
	for enemy in targets:
		var enemy_casted = enemy as BaseEnemy
		enemy_casted.change_speed(0)
		enemy_casted.damage(damage)
		enemies_affected.append(enemy)

	get_tree().create_timer(perc*attack_speed).timeout.connect(on_do_action_timeout)



func on_do_action_timeout():
	# check they dod not die
	for corr_enemy in enemies_affected:
		if is_instance_valid(corr_enemy):
			corr_enemy.reset_speed()
	enemies_affected = []


func add_level_stats():
	if perc < 0.8:
		perc = perc * 1.1
	else:
		if damage == 0:
			damage = 0.1
		damage = damage * 1.1
		attack_speed = attack_speed * 1.1
