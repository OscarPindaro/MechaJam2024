extends BaseMecha

var chosen: Array
var num_staplers: int = 3

func do_action():
	var resource = load("res://scenes/nonProjectile/Stapler.tscn")
	
	while chosen.size() < num_staplers and chosen.size() != targets.size():
		var trg = rng.randi_range(0, targets.size() - 1)
		if not chosen.has(trg):
			chosen.append(trg)
	
	for n in chosen:
		var stapler = resource.instantiate() as Stapler
		parent.add_child(stapler)
		stapler.target = targets[n]
		stapler.damage = damage
		stapler.attack()
	
	chosen.clear()
	
	
func add_level_stats():
	num_staplers = num_staplers + 1
