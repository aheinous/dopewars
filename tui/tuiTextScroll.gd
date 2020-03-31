extends 'res://tui/tuiPopup.gd'

#var pages = []
#var pageNum = 0

var lines = []
var lineNum = 0

export var numLines = 22
export var numColumns = 32





onready var pageDisp = $Panel/tuiVBox/tuiLabel_pure
onready var prevButton = $Panel/tuiVBox/tuiHBox/prevButton
onready var nextButton = $Panel/tuiVBox/tuiHBox/nextButton



# func _setupAndShow(pages):
# 	self.pages = pages
# 	_refreshDisp()
# 	_showPopup()


func setText(text):
	text = util.wordWrap(text, numColumns)
	self.lines = Array(text.split('\n'))
	for i in range(lines.size()):
		lines[i] = util.rpad_chars(numColumns, lines[i])
	_refreshDisp()	

#func setupAndShow():
#	_showPopup()


# func _refreshDisp():
# 	pageDisp.setText(pages[pageNum])
# 	prevButton.disabled = (pageNum == 0)
# 	nextButton.disabled = (pageNum == pages.size()-1)
	

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
