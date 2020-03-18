extends "res://tui/tuiNumEnter.gd"


var mode

func setupAndShow(mode):
	self.mode = mode
	var text = "Cash: $%s\nBank balance: $%s\n%s how much?" \
			% 	[util.toCommaSepStr(gameModel.stats().cash),
				util.toCommaSepStr(gameModel.stats().bank),
				mode ]

	var maxval
	if mode == "Deposit":
		maxval = gameModel.stats().cash
	else:
		maxval = gameModel.stats().bank


	_setupAndShow(0, maxval, '$', text, mode)


func _on_cancelButton_pressed():
	gameModel.leaveBank()
	_hidePopup()


func _on_okayButton_pressed():
	if mode == "Deposit":
		gameModel.deposit(getValue() as int)
	else:
		gameModel.withdraw(getValue() as int)
	_hidePopup()





