extends "res://tui/tuiPopup.gd"

onready var text = $Panel/tuiVBox/text
onready var standFightButton = $Panel/tuiVBox/tuiHBox/StandFightButton
onready var runDealDrugsButton = $Panel/tuiVBox/tuiHBox/RunDealDrugsButton


func _ready():
	hide()


func setupAndShow():
	var s = ''
	var bitches = gameModel.stats().getNumBitches()
	var deputies = gameModel.numDeputies()
	var copHealth = gameModel.copHealth()
	var youHealth = gameModel.stats().health
	var fightText = gameModel.getFightText()
	var copName = gameModel.curCop()


	var sep = '-------------------------------------------------\n'

	s = 'You have: %s bitch%s\n' % [bitches, "" if bitches==1 else "es"]
	s += '%s health: %s%%\n' % ['Bitch' if bitches >= 1 else 'Your', youHealth]
	s+= sep
	
	s+= '%s has: %s %s\n' % [copName, deputies, "deputy" if deputies==1 else "deputies"]
	s+= '%s health: %s%%\n' % ['Deputy' if deputies >= 1 else copName, copHealth]
	s+= sep

	s+= fightText

	text.setText(s)



	if gameModel.fightOver():
		runDealDrugsButton.setText( "View Highscores" if gameModel.gameFinished() else "Deal Drugs" )
		standFightButton.hide()
	else:
		standFightButton.setText( "Fight" if gameModel.canFight() else "Stand" )
		standFightButton.show()
		runDealDrugsButton.setText("Run")
	
	_showPopup()


func _on_StandFightButton_pressed():
	if gameModel.canFight():
		gameModel.fight()
	else:
		gameModel.stand()
	emit_signal("done")


func _on_RunDealDrugsButton_pressed():
	if gameModel.fightOver():
		gameModel.finishFight()
		_hidePopup()
	else:
		gameModel.run()
	emit_signal("done")
