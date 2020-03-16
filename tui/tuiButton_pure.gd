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
	# set_custom_minimum_size(charSize() * TUI.cSize)
	setText(text)

func tuiDraw(tui):
	# print("tuiDraw()")
#	if not is_visible_in_tree():
#		return 
	# var olay = tui_manager.overlay
	if _halfButton:
		tui.drawToTUI(self, util.skinnyButtonStr(charSize, text))
	else:
		tui.drawToTUI(self, util.boxString(charSize, text))
	# print("%s rect size. ratio: %s, %s" % [text, rect_size, rect_size/TUI.cSize])



func setHalfButton(b):
	_halfButton = b
	# set_custom_minimum_size(charSize() * TUI.cSize)
	# set_custom_minimum_size(Vector2(4,4))
	# _refreshMinSize()
	refreshCharSize()



func setText(s:String):
	text = s
	# set_custom_minimum_size(charSize() * TUI.cSize)
	# set_custom_minimum_size(Vector2(4,4))
	# _refreshMinSize()
	refreshCharSize()




# func _refreshMinSize():
# 	set_custom_minimum_size(charSize() * TUI.cSize)
#	print('start size: ', self.rect_size)
#	self.rect_size = Vector2(100,4)
#	print('end rect_size ', self.rect_size)
#	set_custom_minimum_size(Vector2(100,4))

	
func getMinCharSize():
	return Vector2(text.length()+2, 1 if _halfButton else 3)


# func refresh():
# 	var newCharSize = charSize
# 	var minCharSize = _minCharSize()

# 	newCharSize.x = max(minCharSize.x, newCharSize.x)
# 	newCharSize.y = max(minCharSize.y, newCharSize.y)

# 	charSize = newCharSize
	


func is_disabled():
	return disabled

