extends "res://tui/tuiElement.gd"



func tuiDraw(tui):
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, tui.boxStringCS(charSize))



func refresh():
	if not _isReady:
		return
	.refresh()
	if get_child_count() != 1:
		print('n childs: (should be 1) ', get_child_count(), ' ', get_path())
		
		return
#	assert(get_child_count() == 1)
	var child = get_children()[0]
	child.charPos = Vector2(1,1)

	setCharSize(child.charSize + Vector2(2,2))
	
