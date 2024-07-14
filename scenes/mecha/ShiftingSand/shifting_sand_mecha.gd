extends BaseMecha
class_name ShiftingSandMecha


@export_range(0,1,0.1) var speed_multiplier: float = 0.5
@export var charm_duration: float = 1

var flying_group_name: String = "flying"

var enemies_affected: Array[BaseEnemy] = []

func do_action():
	for enemy in targets:
		var enemy_casted = enemy as BaseEnemy
		enemy_casted.push_to_start(speed_multiplier, charm_duration)
		enemies_affected.append(enemy)
	# mean position of enemies
	var mean_pos: Vector2 = Vector2.ZERO
	for enemy in targets:
		mean_pos = mean_pos + $SandParticles.to_local(enemy.global_position)
	mean_pos = mean_pos / len(targets)
	$SandParticles.emitting = true
	$SandParticles.direction = mean_pos.normalized()



# overriding because it should ignore enemies that fly
func on_vision_area_entered(area: Area2D):	
	if area.is_in_group(target_group) and !area.is_in_group(flying_group_name):
		targets.append(area)
		self.connect_to_enemy_death(area)


func on_vision_area_exited(area: Area2D):
	if area.is_in_group(target_group) and area in targets:
		targets.erase(area)

func add_level_stats():
	charm_duration *= 1.1