extends Control

var _halfButton = false
var text = 'default'
signal pressed


func _onSelfPressed():
	print('button "', text, '" pressed')

func _ready():
	TUI.registerElement(self)
	connect("pressed", self, "_onSelfPressed")
	# set_custom_minimum_size(charSize() * TUI.cSize)
	setText(text)
	print('button ready: %s' % text)

func tuiDraw(tui):
	# print("tuiDraw()")
#	if not is_visible_in_tree():
#		return 
	# var olay = tui_manager.overlay
	if _halfButton:
		tui.drawToTUI(self, tui.skinnyButtonStr(rect_size, text))
	else:
		tui.drawToTUI(self, tui.boxString(rect_size, text))
	# print("%s rect size. ratio: %s, %s" % [text, rect_size, rect_size/TUI.cSize])



func setHalfButton(b):
	_halfButton = b
	# set_custom_minimum_size(charSize() * TUI.cSize)
	# set_custom_minimum_size(Vector2(4,4))
	_refreshMinSize()



func setText(s:String):
	text = s
	# set_custom_minimum_size(charSize() * TUI.cSize)
	# set_custom_minimum_size(Vector2(4,4))
	_refreshMinSize()




func _refreshMinSize():
	set_custom_minimum_size(charSize() * TUI.cSize)
#	print('start size: ', self.rect_size)
#	self.rect_size = Vector2(100,4)
#	print('end rect_size ', self.rect_size)
#	set_custom_minimum_size(Vector2(100,4))

	
func charSize():
	return Vector2(text.length()+2, 1 if _halfButton else 3)

