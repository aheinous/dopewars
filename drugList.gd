extends "res://itemList.gd"


func populate():
	_populate(gameModel.drugsHere() + gameModel.drugsOwnedAndNotHere(), config.colWidths_drugs)
