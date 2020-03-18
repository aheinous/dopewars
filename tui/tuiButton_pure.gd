extends "res://tui/tuiElement.gd"

var _halfButton = false
export var disabled := false
export var text := 'default'
signal pressed


func _onSelfPressed():
	print('button "', text, '" pressed')

func _ready():
	TUI.registerElement(self)
	connect("pressed", self, "_onSelfPressed")
	setText(text)

func tuiDraw(tui):
	if _halfButton:
		tui.drawToTUI(self, util.skinnyButtonStr(charSize, text))
	else:
		tui.drawToTUI(self, util.boxString(charSize, text))



func setHalfButton(b):
	_halfButton = b
	refreshCharSize()



func setText(s:String):
	text = s
	refreshCharSize()


	
func getMinCharSize():
	return Vector2(text.length()+2, 1 if _halfButton else 3)


func is_disabled():
	return disabled


