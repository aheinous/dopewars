extends Control

signal charSizeChanged

var charSize : Vector2 = Vector2.ZERO setget setCharSize, getCharSize 
var charPos : Vector2 = Vector2.ZERO setget setCharPos, getCharPos 

var _preferredCharSize = Vector2.ZERO

var _isReady = false

func _ready():
	_isReady = true
	refresh()

func refresh():
	TUI.onNeedRedraw()




func setCharSize(sz : Vector2):
	_preferredCharSize = sz
	refreshCharSize()

func getCharSize():
	return charSize

func refreshCharSize(refreshOnChange=true):
	var sz = Vector2()
	var minSz = getMinCharSize()
	sz.x = max(_preferredCharSize.x, minSz.x)
	sz.y = max(_preferredCharSize.y, minSz.y)
	if sz != charSize:
		charSize = sz
		if refreshOnChange:
			refresh()
		emit_signal("charSizeChanged")
	


func setCharWidth(x):
	_preferredCharSize.x = x
	refreshCharSize()


func setCharHeight(y):
	_preferredCharSize.y = y
	refreshCharSize()


func setCharPos(pos):
	charPos = pos
	rect_position = pos * TUI.cSize

func getCharPos():
	return charPos
	
		
		
func getMinCharSize():
	return Vector2.ZERO

func _onRefresh():
	pass
