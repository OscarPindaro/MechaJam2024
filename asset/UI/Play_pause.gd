extends Button
@onready var PauseSymbol = $/root/GameplayUI/PauseSymbol


func _on_pressed():
	get_tree().paused = !get_tree().paused
	PauseSymbol.visible = !PauseSymbol.visible
