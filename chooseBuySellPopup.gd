extends "res://listChoosePopup.gd"

var drug = "drug"

signal buyPressed
signal sellPressed


func setupAndShow(drug):
    self.drug = drug
    _setupAndShow("Buy or sell %s?" % drug, "Buy", "Sell")


func _on_buttonA_pressed():
	emit_signal("buyPressed", drug)
	hide()

func _on_buttonB_pressed():
	emit_signal("sellPressed", drug)
	hide()
