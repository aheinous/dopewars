extends Control

var text = 'default' setget setText

enum MODE {LEFT_ALIGNED, CENTERED, SKINNY_BUTTON}
var mode = MODE.LEFT_ALIGNED

func _ready():
	TUI.registerElement(self)
	setText(text)

func tuiDraw(tui):
	if mode == MODE.LEFT_ALIGNED:
		tui.drawToTUI(self, text)
	elif mode == MODE.SKINNY_BUTTON:
		tui.drawToTUI(self, tui.skinnyButtonStr(rect_size, text))
	elif mode == MODE.CENTERED:
		tui.drawToTUI(self, tui.centeredStr(rect_size, text))		


func setText(s:String):
	text = s
	_refreshMinSize()


func _refreshMinSize():
	set_custom_minimum_size(charSize() * TUI.cSize)

	
func charSize():
	var maxLnLen = 0
	var curLnLen = 0
	var numLns = 1


	for c in text:
		if c == '\n':
			numLns += 1
			curLnLen = 0
		else:
			curLnLen += 1
			maxLnLen = max(maxLnLen, curLnLen)

	return Vector2(maxLnLen, numLns)
