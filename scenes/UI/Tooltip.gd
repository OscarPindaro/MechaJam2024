extends Panel

func populate(mechaName, description, price):
	%TooltipNameLabel.text = str(mechaName)
	%TooltipDescriptionLabel.text = str(description)
	%TooltipPriceLabel.text = str(price)
