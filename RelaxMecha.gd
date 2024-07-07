extends BaseMecha
class_name RelaxMecha


func do_action():
	var enemy: BaseEnemy = targets.pick_random()
	enemy.damage(self.damage)
