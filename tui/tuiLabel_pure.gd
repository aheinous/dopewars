extends "res://tui/tuiElement.gd"

var text = 'default' setget setText

export var numColumns : int = 50

enum Mode {LEFT_ALIGNED, CENTERED, SKINNY_BUTTON, PLAIN}
export (Mode) var mode = Mode.LEFT_ALIGNED

func _ready():
	TUI.registerElement(self)
	setText(text)

func tuiDraw(tui):
	match mode:
		Mode.LEFT_ALIGNED:
			tui.drawToTUI(self, _wrappedText())
		Mode.SKINNY_BUTTON:
			tui.drawToTUI(self, util.skinnyButtonStr(charSize, _wrappedText()))
		Mode.CENTERED:
			tui.drawToTUI(self, util.centeredStr(charSize, _wrappedText()))	
		Mode.PLAIN:
			tui.drawToTUI(self, text)


func setText(s:String):
	text = s
	refreshCharSize()


func _wrappedText():
	return util.wordWrap(text, numColumns)


func getMinCharSize():
	match mode:
		Mode.LEFT_ALIGNED:
			return util.getCharSize(_wrappedText())
		Mode.SKINNY_BUTTON:
			return util.getCharSize(util.skinnyButtonStr(Vector2.ZERO, _wrappedText()))
		Mode.CENTERED:
			return util.getCharSize(util.centeredStr(Vector2.ZERO, _wrappedText()))	
		Mode.PLAIN:
			return util.getCharSize(text)
