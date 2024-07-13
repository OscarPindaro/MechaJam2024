extends BaseMecha
class_name RelaxMecha


var flying_group_name: String = "flying"

func do_action():
	if !targets.is_empty():
		var enemy: BaseEnemy = targets.pick_random()
		# pick a random enemy
		enemy.damage(self.damage)
		$FootParticle.position = to_local(enemy.position)
		$FootParticle.emitting = true


# overriding because it should ignore enemies that fly
func on_vision_area_entered(area: Area2D):	
	if area.is_in_group(target_group) and !area.is_in_group(flying_group_name):
		targets.append(area)
		self.connect_to_enemy_death(area)


func on_vision_area_exited(area: Area2D):
	if area.is_in_group(target_group) and area in targets:
		targets.erase(area)


func add_level_stats():
	attack_speed = attack_speed * 1.3
	speed = speed * 1.3
