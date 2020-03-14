extends "res://tui/tuiElement.gd"
func _ready():
	connect("resized", self, "_onResized")
	
	
func _onResized():
	setCharSize((rect_size / TUI.cSize).floor())
	# print('resized: ', charSize, (rect_size / TUI.cSize).floor())
	
	
func refresh():
	.refresh()
	assert(get_child_count() == 1)
	var child = get_children()[0]
	child.charPos = (charSize/2  - child.charSize/2).round()
	# print('->',child.charPos, charSize, Vector2(TUI.nCols, TUI.nLines), child.charSize)
	# print('rsz', self.rect_size, $"/root/Game/TUI_Overlay".rect_size, $"/root/Game".rect_size)
