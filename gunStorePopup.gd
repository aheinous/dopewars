extends "res://tui/tuiPopup.gd"

onready var list = $Panel/VBoxContainer/gunList
onready var chooseBuySellPopup = $chooseBuySellPopup


func setupAndShow():
	list.populate()
	_showPopup()


func _on_leaveButton_pressed():
	gameModel.leaveGunStore()
	_hidePopup()


func buy(gunName):
	gameModel.buyGun(gunName)
	emit_signal("done")

func sell(gunName):
	gameModel.sellGun(gunName)
	emit_signal("done")

func _on_gunList_itemButtonPressed(gunName):
	print("gun button pressed: ", gunName)
	if gameModel.canBuyGun(gunName) and gameModel.canSellGun(gunName):
		chooseBuySellPopup.setupAndShow(gunName)
	elif gameModel.canBuyGun(gunName):
		buy(gunName)
	elif gameModel.canSellGun(gunName):
		sell(gunName)


func _on_chooseBuySellPopup_buyPressed(gun):
	buy(gun)


func _on_chooseBuySellPopup_sellPressed(gun):
	sell(gun)

