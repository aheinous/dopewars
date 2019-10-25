extends "res://itemList.gd"


func populate():
	_populate(gameModel.getDrugsHere() + gameModel.getDrugsOwnedAndNotHere(), config.colWidths_drugs)
