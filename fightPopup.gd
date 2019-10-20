extends CenterContainer

signal done

onready var bitchesCounter = $PanelContainer/VBoxContainer/YouSection/HBoxContainer/BitchesCounter
onready var youHealth = $PanelContainer/VBoxContainer/YouSection/HBoxContainer2/HealthProgressBar
onready var officerLabel = $PanelContainer/VBoxContainer/CopSection/HBoxContainer/OfficerLabel
onready var deputiesCounter = $PanelContainer/VBoxContainer/CopSection/HBoxContainer/DeputiesCounter
onready var copHealth = $PanelContainer/VBoxContainer/CopSection/HBoxContainer2/HealthProgressBar
onready var text = $PanelContainer/VBoxContainer/Text
onready var standFightButton = $PanelContainer/VBoxContainer/HBoxContainer/StandFightButton
onready var runDealDrugsButton = $PanelContainer/VBoxContainer/HBoxContainer/RunDealDrugsButton


func _ready():
	hide()


func setupAndShow():
	var bitches = gameModel.stats().bitches
	bitchesCounter.text = "%s bitch%s" % [bitches, "" if bitches==1 else "es"]

	youHealth.value = gameModel.stats().health

	officerLabel.text = gameModel.curCop()

	var deputies = gameModel.numDeputies()
	deputiesCounter.text = "%s %s" % [deputies, "deputy" if deputies==1 else "deputies"]

	copHealth.value = gameModel.fightData.copHealth

	text.text = gameModel.getFightText()


	if gameModel.fightOver():
		runDealDrugsButton.text = "View Highscores" if gameModel.gameFinished() else "Deal Drugs"
		standFightButton.hide()
	else:
		standFightButton.text = "Fight" if gameModel.canFight() else "Stand"
		standFightButton.show()
		runDealDrugsButton.text = "Run"

	show()



func _on_StandFightButton_pressed():
	if gameModel.canFight():
		gameModel.fight()
	else:
		gameModel.stand()
	emit_signal("done")


func _on_RunDealDrugsButton_pressed():
	if gameModel.fightOver():
		gameModel.finishFight()
		hide()
	else:
		gameModel.run()
	emit_signal("done")
