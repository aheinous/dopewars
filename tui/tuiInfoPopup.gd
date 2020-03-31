extends 'res://tui/tuiTextScroll.gd'

func _ready():
	# 	var pages = ['Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut mollis orci a mauris tincidunt, at gravida erat luctus. Nulla placerat enim ut gravida cursus. Proin commodo ex ut ligula posuere finibus aliquet id augue. Suspendisse potenti. Vestibulum condimentum risus ac velit auctor sollicitudin. Pellentesque eget velit ut nisi varius condimentum. Mauris nisl lectus, congue ac nisl in, vehicula efficitur sem. In vulputate fermentum enim non pharetra. Donec molestie semper neque nec feugiat.',
	# 'Sed dictum, purus eget placerat accumsan, odio est egestas quam, vel semper quam ante eget odio. Proin eu cursus turpis. Nullam in tellus non mauris luctus tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla egestas at urna vitae rutrum. Fusce aliquam tempus mi, at imperdiet ipsum volutpat non. Proin ac ligula condimentum, sodales justo id, efficitur magna. Suspendisse pulvinar diam tortor, id molestie nisl sodales id. Quisque pretium nisi ut arcu vehicula volutpat. Mauris accumsan nulla sem, at fringilla velit faucibus id.',
	# 'Donec ac nunc urna. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Quisque id placerat lectus. Nullam eu ipsum vestibulum, mollis nisi ac, lacinia ex. In non porttitor nisi. Fusce vel justo ac dolor porttitor condimentum a quis elit. Integer volutpat velit lacus, ut consectetur dolor pulvinar in. Sed ut mollis risus, non sagittis dolor. Donec laoreet eu eros non facilisis. Fusce eget urna vel odio posuere vehicula. Vestibulum eleifend eros tempor vestibulum scelerisque. Pellentesque ante magna, tincidunt facilisis lacinia eget, dignissim quis neque. Aenean dignissim suscipit enim et consequat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;',
	# 'Vestibulum ut tempor nibh, ac condimentum enim. Duis dolor dui, iaculis sit amet accumsan vitae, imperdiet ac ex. Pellentesque vestibulum tortor id rutrum convallis. Nulla eget luctus risus. Quisque eu erat consectetur, porttitor erat in, auctor nisi. Cras urna nibh, tempus quis finibus vitae, elementum non lectus. Suspendisse laoreet leo at enim efficitur tincidunt. Aliquam sed lobortis turpis. Cras eget odio ac enim lobortis placerat.',
	# 'Nullam vel leo sit amet leo euismod faucibus. Nam luctus lacus enim, eget porta magna porttitor ac. Nullam ac tincidunt lectus. Fusce molestie vel dolor vitae volutpat. Mauris eget neque auctor, posuere massa nec, eleifend nisi. Nunc gravida ante luctus risus feugiat finibus. Nunc vel ipsum vel eros feugiat ultricies. Nam finibus vitae elit vitae efficitur. Fusce in orci sit amet turpis dictum cursus sed nec orci.']
	

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
