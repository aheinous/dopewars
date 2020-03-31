extends 'res://tui/tuiPopup.gd'


var lines = []
var lineNum = 0

export var numLines = 22
export var numColumns = 32


onready var pageDisp = $Panel/tuiVBox/tuiLabel_pure
onready var prevButton = $Panel/tuiVBox/tuiHBox/prevButton
onready var nextButton = $Panel/tuiVBox/tuiHBox/nextButton


func setText(text):
	text = util.wordWrap(text, numColumns)
	self.lines = Array(text.split('\n'))
	for i in range(lines.size()):
		lines[i] = util.rpad_chars(numColumns, lines[i])
	_refreshDisp()	


func _refreshDisp():
	lineNum = min(lineNum, lines.size() - numLines)
	lineNum = max(lineNum, 0)
	pageDisp.setText(PoolStringArray(lines.slice(lineNum, min(lines.size(), lineNum + numLines))).join('\n'))
	prevButton.disabled = (lineNum == 0)
	nextButton.disabled = (lineNum + numLines >= lines.size())
	refresh()


func _on_doneButton_pressed():
	_hidePopup()


func _on_nextButton_pressed():
	lineNum += numLines / 3
	_refreshDisp()
	


func _on_prevButton_pressed():
	lineNum -= numLines / 3
	_refreshDisp()
