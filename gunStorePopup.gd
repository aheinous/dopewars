extends "res://tui/tuiPopup.gd"

onready var list = $Panel/VBoxContainer/gunList
onready var chooseBuySellPopup = $chooseBuySellPopup
onready var spaceLbl = $Panel/VBoxContainer/SpaceLbl
onready var cashLbl = $Panel/VBoxContainer/CashLbl

func setupAndShow():
	list.populate()
	
	var cols = 24
	var space =  "Space: " + str(gameModel.getAvailSpace()) + " / " + str(gameModel.getTotalSpace())
	var cash =  "Cash: $" + util.toCommaSepStr(gameModel.getCash())
	
	cashLbl.setText(cash)
	spaceLbl.setText(space)
	
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

