extends Control


var charSize : Vector2 = Vector2.ZERO setget setCharSize, getCharSize 
var charPos : Vector2 = Vector2.ZERO setget setCharPos, getCharPos 

var _preferredCharSize = Vector2.ZERO

func _ready():
	refresh()



func recenter():
	self.rect_position = util.vec2_roundToMult((get_parent().rect_size - self.rect_size) / 2, TUI.cSize) 


# func charSize():
# 	# return Vector2(rect_size.x/TUI.cWidth, rect_size.y/TUI.cHeight)


func setCharSize(sz : Vector2):
	_preferredCharSize = sz
	# rect_size = sz * TUI.cSize
	refreshCharSize()

func getCharSize():
	return charSize

func refreshCharSize():
	var sz = Vector2()
	var minSz = getMinCharSize()
	sz.x = max(_preferredCharSize.x, minSz.x)
	sz.y = max(_preferredCharSize.y, minSz.y)
	if sz != charSize:
		charSize = sz
		rect_size = charSize * TUI.cSize
		refresh()
	


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

# func refreshMinSize():
# 	set_custom_minimum_size(charSize() * TUI.cSize)


func refresh():
	pass
