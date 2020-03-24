extends "res://tui/tuiPopup.gd"

onready var scores = $Panel/tuiVBox/tuiHBox/scores


func _ready():
	hide()

func setupAndShow():
	var s = ""
	var scoreStrs = []
	var markerStrs = []
	for i in range(gameModel.highscores.size()):
		var score = gameModel.highscores[i]
		if score < 0:
			scoreStrs.append('-$' + util.toCommaSepStr(-score))
		else:
			scoreStrs.append('$' + util.toCommaSepStr(score))
		markerStrs.append(" *" if i == gameModel.highscoreIndex else "")

	scores.text = util.lpadColumnStr([scoreStrs, markerStrs])
	_showPopup()


func _on_restartButton_pressed():
	gameModel.reset()
	_hidePopup()
