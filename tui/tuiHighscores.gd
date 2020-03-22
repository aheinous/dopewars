extends "res://tui/tuiPopup.gd"

onready var scores = $Panel/tuiVBox/tuiHBox/scores


func _ready():
	hide()

func setupAndShow():
	var s = ""
	var scoreStrs = []
	var markerStrs = []
	for i in range(gameModel.highscores.size()-1):
#		s += util.lpad_pixels(font, 300, str(gameModel.highscores[i]))
#		s += " *\n" if i == gameModel.highscoreIndex else "\n"
		scoreStrs.append(util.toCommaSepStr(gameModel.highscores[i]))
		markerStrs.append(" *" if i == gameModel.highscoreIndex else "")

	scores.text = util.lpadColumnStr([scoreStrs, markerStrs])
	_showPopup()


func _on_restartButton_pressed():
	gameModel.reset()
	_hidePopup()
