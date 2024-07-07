extends BaseMecha

var chosen: Array

func do_action():
	var resource = load("res://scenes/nonProjectile/Stapler.tscn")
	
	while chosen.size() < 3 and chosen.size() != targets.size():
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
	
	
