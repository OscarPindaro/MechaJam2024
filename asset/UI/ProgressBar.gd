extends ProgressBar

func change_health(damage: int):
	var tween = create_tween()
	tween.tween_property(self, 'value', value - damage, 0.6)
