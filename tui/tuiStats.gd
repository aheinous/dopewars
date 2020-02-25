extends "tuiLabel.gd"


func populate():
	var fmt = " %-8s %10s"

	var cash =  util.centerFill(19, "Cash:", "$" + util.toCommaSepStr(gameModel.getCash()))
	var guns =  util.centerFill(19, "Guns:", str(gameModel.getNumGuns()))
	var debt =  util.centerFill(19, "Debt:", "$" + util.toCommaSepStr(gameModel.getDebt()))
	var bitches =  util.centerFill(19, "Bitches:", str(gameModel.getBitches()))
	var space =  util.centerFill(19, "Space:", str(gameModel.getAvailSpace()) + " / " + str(gameModel.getTotalSpace()))
	var bank =  util.centerFill(19, "Bank:", "$" + util.toCommaSepStr(gameModel.getBank()))
	# var bank =  util.centerFill(19, "Bank:", "$5,000,000,000")
	var health =  util.centerFill(19, "Health:", str(gameModel.getHealth()))
	var day =  util.centerFill(19, "Day:", str(gameModel.getDay()) + " / " + str(gameModel.getFinalDay()) )


	var nCols = (cash+guns).length()
	var location = util.lrpad_chars(nCols,"-- %s --" % gameModel.getCurPlace())
	
	text = location + "\n" + cash + " " + guns + "\n" 
	text += debt + " " + bitches + "\n" + space + " " + bank + "\n" + health + " " + day
