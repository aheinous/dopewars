extends Control


var Util = preload("res://util.gd")

onready var list = $MarginContainer/VBoxContainer/list
onready var stats = $MarginContainer/VBoxContainer/stats


onready var buySellDropPopup = $buySellDropPopup
onready var chooseBuySellPopup = $chooseBuySellPopup
onready var jetPopup = $jetPopup
onready var choicePopup = $choicePopup
onready var loansharkPopup = $loansharkPopup
onready var bankPopup = $bankPopup
onready var bankChoosePopup = $bankChoosePopup

onready var msgPopup = $msgPopup


func buyDrug(drug):
	buySellDropPopup.setupAndShow("Buy", drug)

func sellDrug(drug):
	buySellDropPopup.setupAndShow("Sell", drug)

func _on_list_drugButtonPressed(drug):
	print("_on_list_drugButtonPressed(%s)" % [drug])

	if gameModel.canBuy(drug) and not gameModel.canSell(drug):
		buyDrug(drug)
	elif not gameModel.canBuy(drug) and gameModel.canSell(drug):
		sellDrug(drug)
	elif gameModel.canBuy(drug) and gameModel.canSell(drug):
		# choose
		chooseBuySellPopup.setupAndShow(drug)
	elif gameModel.canDrop(drug):
		# drop
		buySellDropPopup.setupAndShow("Drop", drug)


func _on_chooseBuySellPopup_buyPressed(drug):
	buyDrug(drug)


func _on_chooseBuySellPopup_sellPressed(drug):
	sellDrug(drug)


func _on_jetButton_pressed():
	jetPopup.go()


func _process(delta):
	stats.populate()
	match gameModel.curState():
		gameModel.State.DRUG_MENU:
			state_drugMenu()
		gameModel.State.MSG_QUEUE:
			state_msgQueue()
		gameModel.State.LOANSHARK:
			state_loanshark()
		gameModel.State.COP_FIGHT:
			pass
		gameModel.State.BANK:
			state_bank()
		gameModel.State.GUNSTORE:
			pass
		gameModel.State.PUB:
			state_msgQueue()
		_:
			print("curState: ",gameModel.curState())
			assert(false)
	set_process(false)


func state_bank():
	bankChoosePopup.setupAndShow()

func state_loanshark():
	loansharkPopup.setupAndShow()

func state_drugMenu():
	list.populate()

func state_msgQueue():
	if gameModel.isOnMsg():
		msgPopup.setupAndShow(gameModel.getMsgText())
	else:
		choicePopup.setupAndShow(gameModel.getMsgText())

func _on_msgPopup_okayPressed():
	gameModel.chooseOkay()
	set_process(true)


func _on_choicePopup_noPressed():
	gameModel.chooseNo()
	set_process(true)


func _on_choicePopup_yesPressed():
	gameModel.chooseYes()
	set_process(true)


func _on_jetPopup_placeButtonPressed(place):
	gameModel.jet(place)
	set_process(true)


func _on_popupDone():
	set_process(true)


func _on_bankChoosePopup_withdrawPressed():
	bankPopup.setupAndShow("Withdraw")


func _on_bankChoosePopup_despositPressed():
	bankPopup.setupAndShow("Deposit")
