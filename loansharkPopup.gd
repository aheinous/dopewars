extends "res://amntPopup.gd"

#signal done

func setupAndShow():
	text.text = "Cash: $%s\nDebt: $%s" % [util.toCommaSepStr(gameModel.getCash()), util.toCommaSepStr(gameModel.getDebt())]
	amntChooser.setup("Pay", gameModel.mostCanPayback(), -1, "$")
	_showPopup()


func _on_cancelButton_pressed():
	_hidePopup()
	gameModel.leaveLoanshark()
#	emit_signal("done")


func _on_okayButton_pressed():
	gameModel.payback(amntChooser.getValue() as int)
	_hidePopup()
#	emit_signal("done")
