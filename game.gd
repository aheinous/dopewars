extends Control
onready var list = $VBoxContainer/list
onready var stats = $VBoxContainer/stats

onready var cashDisp =    $VBoxContainer/CenterContainer/stats/cashDisp
onready var gunsDisp =    $VBoxContainer/CenterContainer/stats/gunsDisp
onready var debtDisp =    $VBoxContainer/CenterContainer/stats/debtDisp
onready var bitchesDisp = $VBoxContainer/CenterContainer/stats/bitchesDisp
onready var spaceDisp =   $VBoxContainer/CenterContainer/stats/spaceDisp
onready var bankDisp =    $VBoxContainer/CenterContainer/stats/bankDisp
onready var healthDisp =  $VBoxContainer/CenterContainer/stats/healthDisp
onready var dayDisp =     $VBoxContainer/CenterContainer/stats/dayDisp

onready var buySellDropPopup = $buySellDropPopup
onready var chooseBuySellPopup = $chooseBuySellPopup
onready var jetPopup = $jetPopup
onready var choicePopup = $choicePopup

#onready var MsgPopup = preload("res://msgPopup.tscn")
onready var msgPopup = $msgPopup

func populateStats():
	var stats = gameModel.stats()
	cashDisp.text = "$" + str(stats.cash)
	gunsDisp.text = str(stats.guns)
	debtDisp.text = "$" + str(stats.debt)
	bitchesDisp.text = str(stats.bitches)
	spaceDisp.text = str(stats.availSpace) + " / " + str(stats.totalSpace)
	bankDisp.text = "$" + str(stats.bank)
	healthDisp.text = str(stats.health)
	dayDisp.text = str(stats.day) + " / " + str(stats.finalDay)



func _ready():

	pass
	# loop()

	# print("hiding")
	# buySellDropPopup.hide()

	# gameModel.connect("updated", self, "on_gameModel_updated")
	# gameModel.connect("msgsAvail", self, "on_gameModel_msgsAvail")
	# gameModel.connect("choicesAvail", self, "on_gameModel_choicesAvail")
	# on_gameModel_updated()


# func on_gameModel_choicesAvail():
# 	choicePopup.setupAndShow(gameModel.curChoiceDesc(), gameModel, "chooseYes")



# # func on_gameModel_updated():
# # 	list.populate()
# # 	populateStats()
# # #	pass

# func on_gameModel_msgsAvail():
# 	if gameModel.msgs.size() > 0:
# #		var msgPopup = MsgPopup.instance()
# #		add_child(msgPopup)
# 		msgPopup.setupAndShow(gameModel.msgs)
# 	pass



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
#		buySellDropPopup.verb = "Drop"
#		buySellDropPopup.drug = drug
		buySellDropPopup.setupAndShow("Drop", drug)




func _on_chooseBuySellPopup_buyPressed(drug):
	print("sell slot")
	buyDrug(drug)


func _on_chooseBuySellPopup_sellPressed(drug):
	print("buy sdlot")
	sellDrug(drug)


func _on_jetButton_pressed():
	jetPopup.go()


func _process(delta):
	match gameModel.curState():
		gameModel.State.DRUG_MENU:
			state_drugMenu()
		gameModel.State.MSG_QUEUE:
			state_msgQueue()
		gameModel.State.LOANSHARK:
			pass
		gameModel.State.COP_FIGHT:
			pass
		gameModel.State.BANK:
			pass
		gameModel.State.GUNSTORE:
			pass
		gameModel.State.PUB:
			pass
		_:
			print("curState: ",gameModel.curState())
			assert(false)
	set_process(false)


func state_drugMenu():
	print("DRUG MENU")
	list.populate()
	populateStats()

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


func _on_buySellDropPopup_buySellDropPressed():
	set_process(true)
