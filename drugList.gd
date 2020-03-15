extends "res://tuiItemList_pure.gd"


func populate():
	_populate(gameModel.getDrugsHere() + gameModel.getDrugsOwnedAndNotHere(), config.colWidths_chars_drugs)
