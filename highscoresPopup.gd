extends CenterContainer

onready var scores = $PanelContainer/VBoxContainer/scores

signal done


func _ready():
	hide()

func setupAndShow():
	var s = ""
	var font = scores.get_font("font")
	var scoreStrs = []
	var markerStrs = []
	for i in range(gameModel.highscores.size()-1):
#		s += util.lpad_pixels(font, 300, str(gameModel.highscores[i]))
#		s += " *\n" if i == gameModel.highscoreIndex else "\n"
		scoreStrs.append(util.toCommaSepStr(gameModel.highscores[i]))
		markerStrs.append(" *" if i == gameModel.highscoreIndex else "")

	scores.text = util.lpadColumnStr(font, [scoreStrs, markerStrs])
	show()


func _on_restartButton_pressed():
	gameModel.reset()
	hide()
	emit_signal("done")
