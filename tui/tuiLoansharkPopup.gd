extends "res://tui/tuiNumEnter.gd"


func setupAndShow():
	var text = "Cash: $%s\nDebt: $%s\n" % [util.toCommaSepStr(gameModel.getCash()), util.toCommaSepStr(gameModel.getDebt())]
	text += "Pay how much?"
	var maxval = gameModel.mostCanPayback()

	_setupAndShow(maxval, maxval, "$", text, "Pay")	


func _on_cancelButton_pressed():
	_hidePopup()
	gameModel.leaveLoanshark()



func _on_okayButton_pressed():
	gameModel.payback(getValue() as int)
	_hidePopup()

