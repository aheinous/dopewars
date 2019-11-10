extends "res://amntPopup.gd"

signal done

func setupAndShow():
	text.text = "Cash: $%s\nDebt: $%s" % [util.toCommaSepStr(gameModel.getCash()), util.toCommaSepStr(gameModel.getDebt())]
	amntChooser.setup("Pay", gameModel.mostCanPayback())
	show()


func _on_cancelButton_pressed():
	hide()
	gameModel.leaveLoanshark()
	emit_signal("done")


func _on_payButton_pressed():
	gameModel.payback(amntChooser.getValue() as int)
	hide()
	emit_signal("done")
