extends "res://amntPopup.gd"

var verb = "Buy"
var drug = "drug"


func setupAndShow(verb, drug):
	self.drug = drug
	self.verb = verb
	match verb:
		"Buy":
			text.text = "Buy %s at $%s\nCan afford: %s\nAvailable Space: %s\n" \
					% [drug, \
					util.toCommaSepStr(gameModel.getDrugPrice(drug)), \
					util.toCommaSepStr(gameModel.getNumDrugCanAfford(drug)), \
					util.toCommaSepStr(gameModel.getAvailSpace()) ]
			amntChooser.setup(verb, gameModel.getMostDrugCanBuy(drug))
		"Drop":
			text.text = "Drop %s.\nAvailable Space: %s\n" \
					% [drug, \
					util.toCommaSepStr(gameModel.getAvailSpace())]
			amntChooser.setup(verb, gameModel.getNumDrugHave(drug))
		"Sell":
			text.text = "Sell %s at $%s\nYou have: %s\nAvailable Space: %s\n" \
					% [drug, \
					util.toCommaSepStr(gameModel.getDrugPrice(drug)), \
					util.toCommaSepStr(gameModel.getNumDrugHave(drug)), \
					util.toCommaSepStr(gameModel.getAvailSpace())]
			amntChooser.setup(verb, gameModel.getNumDrugHave(drug))
		_:
			assert(false)

	okayButton.text = verb
	refresh()
	_showPopup()


func _on_cancelButton_pressed():
	_hidePopup()


func _on_okayButton_pressed():
	match verb:
		"Buy":
			gameModel.buyDrug(drug, amntChooser.getValue())
		"Drop":
			gameModel.dropDrug(drug, amntChooser.getValue())
		"Sell":
			gameModel.sellDrug(drug, amntChooser.getValue())
		_:
			assert(false)
	_hidePopup()
