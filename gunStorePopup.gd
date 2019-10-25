extends CenterContainer

onready var list = $PanelContainer/VBoxContainer/gunList
onready var chooseBuySellPopup = $chooseBuySellPopup

signal done


func _ready():
	hide()


func setupAndShow():
	list.populate()
	show()

func _on_leaveButton_pressed():
	gameModel.leaveGunStore()
	emit_signal("done")
	hide()


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

