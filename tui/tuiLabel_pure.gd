extends Control

var text = 'default'



func _ready():
	TUI.registerElement(self)
	setText(text)
	print('label ready: %s' % text)

func tuiDraw(tui):
	tui.drawToTUI(self, tui.skinnyButtonStr(rect_size, text))


func setText(s:String):
	text = s
	_refreshMinSize()




func _refreshMinSize():
	set_custom_minimum_size(charSize() * TUI.cSize)

	
func charSize():
	return Vector2(text.length(),1)

