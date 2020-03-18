extends "res://tuiItemList_pure.gd"

func populate():
	_populate(gameModel.getGunsHere(), config.colWidths_chars_guns)
