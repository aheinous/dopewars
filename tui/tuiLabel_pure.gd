extends "res://tui/tuiElement.gd"

var text = 'default' setget setText

export var numColumns : int = 50

enum MODE {LEFT_ALIGNED, CENTERED, SKINNY_BUTTON}
var mode = MODE.LEFT_ALIGNED

func _ready():
	TUI.registerElement(self)
	setText(text)

func tuiDraw(tui):
	if mode == MODE.LEFT_ALIGNED:
		tui.drawToTUI(self, _wrappedText())
	elif mode == MODE.SKINNY_BUTTON:
		tui.drawToTUI(self, tui.skinnyButtonStr(rect_size, _wrappedText()))
	elif mode == MODE.CENTERED:
		tui.drawToTUI(self, tui.centeredStr(rect_size, _wrappedText()))		


func setText(s:String):
	text = s
	refreshCharSize()


func _wrappedText():
	return util.wordWrap(text, numColumns)


func getMinCharSize():
	return util.getCharSize(_wrappedText())
