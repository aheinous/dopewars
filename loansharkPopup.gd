extends "res://amntPopup.gd"

signal loansharkClosed

func setupAndShow():
	text.text = "Cash: $%s\nDebt: $%s" % [Util.toCommaSepStr(gameModel._stats.cash), Util.toCommaSepStr(gameModel._stats.debt)]
	amntChooser.setup("Pay", gameModel.mostCanPayback())
	show()


func _on_cancelButton_pressed():
	hide()
	gameModel.leaveLoanshark()
	emit_signal("loansharkClosed")


func _on_payButton_pressed():
	gameModel.payback(amntChooser.getValue())
	hide()
	emit_signal("loansharkClosed")
