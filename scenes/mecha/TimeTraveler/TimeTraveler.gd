extends Node2D

signal start_time_travelling()
signal end_time_travelling()

@export var test: bool = false
# Called when the node enters the scene tree for the first time.


func _input(event):
	if test:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:	
			activate()

func _ready():
	$AnimatedSprite2D.visible = false


func activate():
	start_time_travelling.emit()
	$EffectPlayer.play()
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.visible = true
	get_tree().paused = true
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.damage(enemy.hp)
	end_time_travelling.emit()


func _on_effect_player_finished():
	get_tree().paused = false
	queue_free()
