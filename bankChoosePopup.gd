extends "res://listChoosePopup.gd"

signal despositPressed
signal withdrawPressed

func setupAndShow():
	_setupAndShow("Deposit or withdraw?", "Deposit", "Withdraw")

func _on_buttonA_pressed():
	hide()
	emit_signal("despositPressed")


func _on_buttonB_pressed():
	hide()
	emit_signal("withdrawPressed")
