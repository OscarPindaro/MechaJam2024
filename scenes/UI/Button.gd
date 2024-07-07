extends Button
#@onready var PopupShopVar = $"/root/PopupShop/PopupShopCanvas"

func _on_mouse_entered():
	#PopupShop.show_popup(Rect2i(Vector2i(global_position), Vector2i(size)),null)
	%Tooltip.global_position.x = self.global_position.x + self.size.x + 20
	
	if self.global_position.y + %Tooltip.size.y < get_viewport_rect().size.y - 20:
		%Tooltip.global_position.y = self.global_position.y
	else:
		%Tooltip.global_position.y = self.global_position.y - (%Tooltip.size.y - self.size.y)
	
	print(%Tooltip.global_position.x)
	print(%Tooltip.global_position.y + %Tooltip.size.y)
	%Tooltip.visible = true
	
func _on_mouse_exited():
	#PopupShop.hide_popup()
	%Tooltip.visible = false

func _on_pressed():
	print('pressed')
