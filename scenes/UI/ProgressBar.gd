extends ProgressBar

func change_health(damage: int):
	var tween = create_tween()
	tween.tween_property(self, 'value', value - damage, 0.6)

func _on_game_manager_health_change(_delta, tot):
	var tween = create_tween()
	tween.tween_property(self, 'value', tot, 0.6)
