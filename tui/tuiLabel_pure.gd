extends "res://tui/tuiElement.gd"

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
	refreshMinSize()



func charSize():
	return util.getCharSize(self.text)
