extends Control

func show_popup(slot: Rect2i, item):

	var mouse_pos = get_viewport().get_mouse_position()
	var correction = 0
	
	if mouse_pos.x >= get_viewport_rect().size.x/2:
		correction = Vector2i(slot.size.x, 0)
	else:
		correction = Vector2i(%PopupShopCanvas.size.x, 0)	
	
	
	%PopupShopCanvas.popup(Rect2i(slot.position + correction, %PopupShopCanvas.size))
	
	
func hide_popup():
	%PopupShopCanvas.hide()
