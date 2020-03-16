extends "res://tui/tuiElement.gd"

var text = 'default' setget setText

export var numColumns : int = 50

enum Mode {LEFT_ALIGNED, CENTERED, SKINNY_BUTTON, PLAIN}
export (Mode) var mode = Mode.LEFT_ALIGNED

func _ready():
	TUI.registerElement(self)
	setText(text)

func tuiDraw(tui):
	tui.drawToTUI(self, _formatText(charSize))


func setText(s:String):
	text = s
	refreshCharSize()



func _formatText(size):
	match mode:
		Mode.LEFT_ALIGNED:
			return _wrappedText()
		Mode.SKINNY_BUTTON:
			return util.skinnyButtonStr(size, _wrappedText())
		Mode.CENTERED:
			return util.centeredStr(size, _wrappedText())
		Mode.PLAIN:
			return text
		_:
			assert(false)

			
func _wrappedText():
	return util.wordWrap(text, numColumns)



func getMinCharSize():
	return util.getCharSize(_formatText(Vector2.ZERO))
