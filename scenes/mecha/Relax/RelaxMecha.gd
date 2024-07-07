extends BaseMecha
class_name RelaxMecha


var flying_group_name: String = "flying"

func do_action():
	if !targets.is_empty():
		var enemy: BaseEnemy = targets.pick_random()
		# pick a random enemy
		enemy.damage(self.damage)


# overriding because it should ignore enemies that fly
func on_vision_area_entered(area: Area2D):	
	if area.is_in_group(target_group) and !area.is_in_group(flying_group_name):
		targets.append(area)


func on_vision_area_exited(area: Area2D):
	if area.is_in_group(target_group) and area in targets:
		targets.erase(area)
