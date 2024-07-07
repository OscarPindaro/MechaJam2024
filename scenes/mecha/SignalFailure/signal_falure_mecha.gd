extends BaseMecha
class_name SignalFailureMecha


@export_range(0,0.9, 0.1) var perc: float = 0.5

var enemies_affected: Array[BaseEnemy] = []

func do_action():
	for enemy in targets:
		var enemy_casted = enemy as BaseEnemy
		enemy_casted.change_speed(0)
		enemies_affected.append(enemy)

	get_tree().create_timer(perc*attack_speed).timeout.connect(on_do_action_timeout)



func on_do_action_timeout():
	for corr_enemy in enemies_affected:
		corr_enemy.reset_speed()
	enemies_affected = []