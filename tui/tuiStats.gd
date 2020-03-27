extends "res://tui/tuiLabel_pure.gd"


func populate():
	var fmt = " %-8s %10s"


	var cols = 16

	var cash =  util.centerFill(cols, "Cash:", "$" + util.toCommaSepStr(gameModel.getCash()))
	var guns =  util.centerFill(cols, "Guns:", str(gameModel.getNumGuns()))
	var debt =  util.centerFill(cols, "Debt:", "$" + util.toCommaSepStr(gameModel.getDebt()))
	var bitches =  util.centerFill(cols, "Bitches:", str(gameModel.getBitches()))
	var space =  util.centerFill(cols, "Space:", str(gameModel.getAvailSpace()) + " / " + str(gameModel.getTotalSpace()))
	var bank =  util.centerFill(cols, "Bank:", "$" + util.toCommaSepStr(gameModel.getBank()))
	# var bank =  util.centerFill(cols, "Bank:", "$5,000,000,000")
	var health =  util.centerFill(cols, "Health:", str(gameModel.getHealth()))
	var day =  util.centerFill(cols, "Day:", str(gameModel.getDay()) + " / " + str(gameModel.getFinalDay()) )


	var nCols = (cash+guns).length()
	var location = util.lrpad_chars(nCols,"-- %s --" % gameModel.getCurPlace())
	
	text = location + "\n" + cash + " " + guns + "\n" 
	text += debt + " " + bitches + "\n" + space + " " + bank + "\n" + health + " " + day
	
	setText(text)
