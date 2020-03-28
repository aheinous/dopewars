extends "res://tuiItemList_pure.gd"

func populate():
	_populate(gameModel.getGunsHere(), config.colWidths_chars_guns)



func _addHeader(_colWidths):
	pass


func _addButton(item, _colWidths):
	var button = TuiButton.instance()

	var nCols = 24
	var s = util.rpad_chars(nCols, item.itemName) + '\n'
	s += util.centerFill(
			nCols, 
			'Have:' + util.toCommaSepStr(item.quantity), 
			'$' + util.toCommaSepStr(item.price)
		)+'\n'

	var cfg = config.gunsByName[item.itemName]
	s += util.centerFill(
		nCols, 
		'Space:' + util.toCommaSepStr(cfg.space), 
		'Dmg:' + util.toCommaSepStr(cfg.damage) + (' splash' if cfg.splash else '')
	)
	
	button.setText(s)
	# button.setHalfButton(true)
	self.add_child(button)
	button.connect("pressed", self, "onItemButtonPressed", [item.itemName])
	button.errorOnPress = not item.enabled
