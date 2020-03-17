extends "res://tui/tuiElement.gd"
func _ready():
	connect("resized", self, "_onResized")
	
	
func _onResized():
	setCharSize((rect_size / TUI.cSize).floor())
	# print('resized: ', charSize, (rect_size / TUI.cSize).floor())
	
	
func _onRefresh():
	assert(get_child_count() == 1)
	var child = get_children()[0]
	child.charPos = (charSize/2  - child.charSize/2).round()
