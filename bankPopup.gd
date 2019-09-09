extends "res://amntPopup.gd"

var mode

signal done

func setupAndShow(mode):
	self.mode = mode
	text.text = "%s how much?\nCash: %s\nBank balance: %s" \
			% 	[mode,
				Util.toCommaSepStr(gameModel.stats().cash),
				Util.toCommaSepStr(gameModel.stats().bank) ]

	if mode == "Deposit":
		amntChooser.setup("Deposit", gameModel.stats().cash)
	else:
		amntChooser.setup("Withdraw", gameModel.stats().bank)

	okayButton.text = mode

	show()


func _on_cancelButton_pressed():
	gameModel.leaveBank()
	emit_signal("done")
	hide()


func _on_okayButton_pressed():
	if mode == "Deposit":
		gameModel.deposit(amntChooser.getValue())
	else:
		gameModel.withdraw(amntChooser.getValue())
	emit_signal("done")
	hide()


