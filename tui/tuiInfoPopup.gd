extends 'res://tui/tuiTextScroll.gd'

func _ready():
	var s = 'DRUGS:\n'

	for cfg in config.drugs:
		s += '\n' + cfg.drugName + '\n'
		s += '  Price: $%s - $%s\n' % [util.toCommaSepStr(cfg.minPrice), util.toCommaSepStr(cfg.maxPrice)]
		if cfg.canBeLow:
			s += ' Price can be unusually low.'
			if cfg.lowString.length() > 0:
				s += ' (' + cfg.lowString + ')'
			s += '\n'
		if cfg.canBeHigh:
			s += ' Price can be unusually high.\n'
	

	s += '\n\nNEIGHBORHOODS:\n'

	for cfg in config.places:
		s += '\n' + cfg.placeName + '\n'
		s += 'Number of drugs: %s - %s\n' % [util.toCommaSepStr(cfg.minDrugs), util.toCommaSepStr(cfg.maxDrugs)]
		s += 'Police: ' + str(cfg.police) + '\n'

	s += '\n\nGUNS:\n'

	for cfg in config.guns:
		s += '\n' + cfg.gunName + '\n'
		s += 'Price: $' + util.toCommaSepStr(cfg.price) + '\n'
		s += 'Space: ' + str(cfg.space) + '\n'
		s += 'Damage: ' + str(cfg.damage)
		if cfg.splash:
			s += ' splash'
		s+= '\n'
	setText(s)

	

func setupAndShow():
	_showPopup()
