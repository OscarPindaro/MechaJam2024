extends PanelContainer

func populate(mechaName, description, lvlUp, bought):
	%TooltipNameLabel.text = str(mechaName)
	%TooltipDescriptionLabel.text = str(description)
	if bought:
		%LvlUpSeparator.visible = true
		%TooltipLvlUpLabel.visible = true
		%TooltipLvlUpLabel.text = "Level Up:\n" + lvlUp
	
	size = Vector2(0, 0)	# Set size to fit
