extends "res://amntPopup.gd"

var mode

func setupAndShow(mode):
	self.mode = mode
	text.text = "%s how much?\nCash: %s\nBank balance: %s" \
			% 	[mode,
				util.toCommaSepStr(gameModel.stats().cash),
				util.toCommaSepStr(gameModel.stats().bank) ]

	if mode == "Deposit":
		amntChooser.setup("Deposit", gameModel.stats().cash)
	else:
		amntChooser.setup("Withdraw", gameModel.stats().bank)

	okayButton.text = mode

	_showPopup()


func _on_cancelButton_pressed():
	gameModel.leaveBank()
	_hidePopup()


func _on_okayButton_pressed():
	if mode == "Deposit":
		gameModel.deposit(amntChooser.getValue() as int)
	else:
		gameModel.withdraw(amntChooser.getValue() as int)
	_hidePopup()



