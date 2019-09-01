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
	cashDisp.text = "$" + str(gameModel.cash)
	gunsDisp.text = str(gameModel.guns)
	debtDisp.text = "$" + str(gameModel.debt)
	bitchesDisp.text = str(gameModel.bitches)
	spaceDisp.text = str(gameModel.availSpace) + " / " + str(gameModel.totalSpace)
	bankDisp.text = "$" + str(gameModel.bank)
	healthDisp.text = str(gameModel.health)
	dayDisp.text = str(gameModel.day) + " / " + str(gameModel.finalDay)



func _ready():

	print("hiding")
	buySellDropPopup.hide()

	gameModel.connect("updated", self, "on_gameModel_updated")
	gameModel.connect("msgsAvail", self, "on_gameModel_msgsAvail")
	gameModel.connect("choicesAvail", self, "on_gameModel_choicesAvail")
	on_gameModel_updated()


func on_gameModel_choicesAvail():
	choicePopup.setupAndShow(gameModel.curChoiceDesc(), gameModel, "chooseYes")



func on_gameModel_updated():
	list.populate()
	populateStats()
#	pass

func on_gameModel_msgsAvail():
	if gameModel.msgs.size() > 0:
#		var msgPopup = MsgPopup.instance()
#		add_child(msgPopup)
		msgPopup.setupAndShow(gameModel.msgs)
	pass



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
