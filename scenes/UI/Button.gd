extends Button
#@onready var PopupShopVar = $"/root/PopupShop/PopupShopCanvas"

var mechaData : MechaStatResource
var bought : bool = false

signal pressed_unpaused()

func _on_mouse_entered():
	#PopupShop.show_popup(Rect2i(Vector2i(global_position), Vector2i(size)),null)
	%Tooltip.global_position.x = self.global_position.x + self.size.x + 20
	
	if self.global_position.y + %Tooltip.size.y < get_viewport_rect().size.y - 20:
		%Tooltip.global_position.y = self.global_position.y
	else:
		%Tooltip.global_position.y = self.global_position.y - (%Tooltip.size.y - self.size.y)
	
	%Tooltip.visible = true
	%Tooltip.populate(mechaData.tooltipName, mechaData.tooltipDescription, mechaData.tooltipLvlUp, bought)
	
func _on_mouse_exited():
	#PopupShop.hide_popup()
	%Tooltip.visible = false
	%LvlUpSeparator.visible = false
	%TooltipLvlUpLabel.visible = false

func _on_pressed():
	if !get_tree().paused:
		pressed_unpaused.emit()

func _on_money_change(_delta, tot):
	if bought:
		disabled = mechaData.lvlCost > tot
	else:
		disabled = mechaData.cost > tot
