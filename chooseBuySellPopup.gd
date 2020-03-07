extends "res://listChoosePopup.gd"

var item = "item"

signal buyPressed
signal sellPressed


func setupAndShow(item):
	self.item = item
	_setupAndShow("Buy or sell %s?" % item, "Buy", "Sell")


func _on_buttonA_pressed():
	emit_signal("buyPressed", item)
	hide()

func _on_buttonB_pressed():
	emit_signal("sellPressed", item)
	hide()
