extends "res://tui/tuiElement.gd"

onready var drugList = $tuiCenter/tuiVBox/drugList
onready var stats = $tuiCenter/tuiVBox/tuiStats
onready var buySellDropPopup = $buySellDropPopup
onready var chooseBuySellPopup = $chooseBuySellPopup
onready var jetPopup = $tuiJetPopup
onready var choicePopup = $tuiChoicePopup
onready var loansharkPopup = $loansharkPopup
onready var bankPopup = $bankPopup
onready var bankChoosePopup = $bankChoosePopup
onready var gunStorePopup = $gunStorePopup
onready var highscoresPopup = $highscoresPopup
onready var fightPopup = $fightPopup
onready var infoPopup = $tuiInfoPopup
onready var msgPopup = $tuiMsgPopup


var jetSoundEnabled = false

func _ready():
	gameModel.connect('stateChanged', self, '_onStateChanged')

func _onStateChanged(prev, cur):
	if (prev == gameModel.State.COP_FIGHT and cur != gameModel.State.COP_FIGHT) \
	or prev == gameModel.State.DRUG_MENU and cur != gameModel.State.COP_FIGHT:
		if jetSoundEnabled:
			$"JetSound".play()
			jetSoundEnabled = false


func buyDrug(drug):
	buySellDropPopup.setupAndShow("Buy", drug)

func sellDrug(drug):
	buySellDropPopup.setupAndShow("Sell", drug)

func _on_drugList_itemButtonPressed(drug):
	if gameModel.canBuyDrug(drug) and not gameModel.canSellDrug(drug):
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
	jetPopup.setupAndShow()


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
	refresh()
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
	jetSoundEnabled = true
	gameModel.jet(place)
	set_process(true)


func _on_popupDone():
	set_process(true)


func _on_bankChoosePopup_withdrawPressed():
	bankPopup.setupAndShow("Withdraw")


func _on_bankChoosePopup_despositPressed():
	bankPopup.setupAndShow("Deposit")


func _on_bankChoosePopup_cancelPressed():
	gameModel.leaveBank()


func _on_GuideButton_pressed():
	infoPopup.setupAndShow()


func _on_AbandonButton_pressed():
	gameModel.abandon()
	set_process(true)
