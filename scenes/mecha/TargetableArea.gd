extends Area2D
class_name TargetableMechaArea

signal buff_attSp_Signal(value:float,time:float)
signal buff_damage_Signal(value:float,time:float)
signal get_damaged_Signal(value:float)

func buff_attSp(value:float,time:float):
	buff_attSp_Signal.emit(value, time)
func buff_damage(value:float,time:float):
	buff_damage_Signal.emit(value, time)
func get_damaged(value:float):
	get_damaged_Signal.emit(value)
