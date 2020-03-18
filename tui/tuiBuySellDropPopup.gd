extends "res://tui/tuiNumEnter.gd"


var verb = "Buy"
var drug = "drug"


func setupAndShow(verb, drug):
	self.drug = drug
	self.verb = verb
	var text
	var maxval
	match verb:
		"Buy":
			text = "Buy %s at $%s\nCan afford: %s\nAvailable Space: %s\n" \
					% [drug, \
					util.toCommaSepStr(gameModel.getDrugPrice(drug)), \
					util.toCommaSepStr(gameModel.getNumDrugCanAfford(drug)), \
					util.toCommaSepStr(gameModel.getAvailSpace()) ]
			maxval = gameModel.getMostDrugCanBuy(drug)
		"Drop":
			text = "Drop %s.\nAvailable Space: %s\n" \
					% [drug, \
					util.toCommaSepStr(gameModel.getAvailSpace())]
			maxval = gameModel.getNumDrugHave(drug)
		"Sell":
			text = "Sell %s at $%s\nYou have: %s\nAvailable Space: %s\n" \
					% [drug, \
					util.toCommaSepStr(gameModel.getDrugPrice(drug)), \
					util.toCommaSepStr(gameModel.getNumDrugHave(drug)), \
					util.toCommaSepStr(gameModel.getAvailSpace())]
			maxval = gameModel.getNumDrugHave(drug)
		_:
			assert(false)

	text += "\n" + verb + " how many?"
	_setupAndShow(maxval, maxval, "", text, verb)



func _on_okayButton_pressed():
	match verb:
		"Buy":
			gameModel.buyDrug(drug, getValue())
		"Drop":
			gameModel.dropDrug(drug, getValue())
		"Sell":
			gameModel.sellDrug(drug, getValue())
		_:
			assert(false)
	_hidePopup()
