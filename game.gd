extends Control

onready var drugList = $MarginContainer/VBoxContainer/drugList
#onready var stats = $MarginContainer/VBoxContainer/stats
onready var stats = $MarginContainer/VBoxContainer/tuiStats


onready var buySellDropPopup = $buySellDropPopup
onready var chooseBuySellPopup = $chooseBuySellPopup
#onready var jetPopup = $jetPopup
onready var jetPopup = $tuiJetPopup

onready var choicePopup = $choicePopup
onready var loansharkPopup = $loansharkPopup
onready var bankPopup = $bankPopup
onready var bankChoosePopup = $bankChoosePopup
onready var gunStorePopup = $gunStorePopup
onready var highscoresPopup = $highscoresPopup
onready var fightPopup = $fightPopup

onready var msgPopup = $tuiMsgPopup


func buyDrug(drug):
	buySellDropPopup.setupAndShow("Buy", drug)

func sellDrug(drug):
	buySellDropPopup.setupAndShow("Sell", drug)

func _on_drugList_itemButtonPressed(drug):
	print("_on_list_drugButtonPressed(%s)" % [drug])

	if not gameModel.canSellDrug(drug) and not gameModel.canDropDrug(drug): # show buy menu if buy is the only option *or* if there are no options
		buyDrug(drug)
	elif not gameModel.canBuyDrug(drug) and gameModel.canSellDrug(drug):
		sellDrug(drug)
	elif gameModel.canBuyDrug(drug) and gameModel.canSellDrug(drug):
		# choose
		chooseBuySellPopup.setupAndShow(drug)
	elif gameModel.canDropDrug(drug):
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
			state_copFight()
		gameModel.State.BANK:
			state_bank()
		gameModel.State.GUNSTORE:
			state_gunStore()
		gameModel.State.PUB:
			state_msgQueue()
		gameModel.State.HIGHSCORES:
			state_highscores()
		_:
			print("curState: ",gameModel.curState())
			assert(false)
	set_process(false)

func state_highscores():
	highscoresPopup.setupAndShow()

func state_gunStore():
	gunStorePopup.setupAndShow()

func state_bank():
	bankChoosePopup.setupAndShow()

func state_loanshark():
	loansharkPopup.setupAndShow()

func state_drugMenu():
	drugList.populate()

func state_msgQueue():
	if gameModel.isOnMsg():
		msgPopup.setupAndShow(gameModel.getMsgText())
	else:
		choicePopup.setupAndShow(gameModel.getMsgText())

func state_copFight():
	fightPopup.setupAndShow()

func _on_msgPopup_okayPressed():
	gameModel.chooseOkay()
	set_process(true)


func _on_choicePopup_noPressed():
	gameModel.chooseNo()
	set_process(true)


func _on_choicePopup_yesPressed():
	gameModel.chooseYes()
	set_process(true)


func _on_tuiJetPopup_placeButtonPressed(place):
	gameModel.jet(place)
	set_process(true)


func _on_popupDone():
	set_process(true)


func _on_bankChoosePopup_withdrawPressed():
	bankPopup.setupAndShow("Withdraw")


func _on_bankChoosePopup_despositPressed():
	bankPopup.setupAndShow("Deposit")
