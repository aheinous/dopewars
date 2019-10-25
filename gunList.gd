extends "res://itemList.gd"

func populate():
	_populate(gameModel.getGunsHere(), config.colWidths_guns)