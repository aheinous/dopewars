extends "res://amntPopup.gd"


var verb = "Buy"
var drug = "drug"


signal buySellDropPressed


func setupAndShow(verb, drug):
	self.drug = drug
	self.verb = verb
	match verb:
		"Buy":
			text.text = "Buy %s at $%s\nCan afford: %s\nAvailable Space: %s" \
					% [drug, gameModel.price(drug), gameModel.canAfford(drug), gameModel.stats().availSpace]
			amntChooser.setup(verb, gameModel.mostCanBuy(drug))
		"Drop":
			text.text = "Drop %s.\nAvailable Space: %s" \
					% [drug, gameModel.stats().availSpace]
			amntChooser.setup(verb, gameModel.quantity(drug))
		"Sell":
			text.text = "Sell %s at $%s\nYou have: %s\nAvailable Space: %s" \
					% [drug, gameModel.price(drug), gameModel.quantity(drug), gameModel.stats().availSpace]
			amntChooser.setup(verb, gameModel.quantity(drug))
		_:
			assert(false)

	okayButton.text = verb

	show()


func _on_cancelButton_pressed():
	hide()


func _on_okayButton_pressed():
	match verb:
		"Buy":
			gameModel.buy(drug, amntChooser.getValue())
		"Drop":
			gameModel.drop(drug, amntChooser.getValue())
		"Sell":
			gameModel.sell(drug, amntChooser.getValue())
		_:
			assert(false)
	hide()
	emit_signal("buySellDropPressed")
