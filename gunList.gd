extends "res://itemList.gd"

func populate():
	_populate(gameModel.guns(), config.colWidths_guns)