extends "res://tui/tuiElement.gd"



func tuiDraw(tui):
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, util.boxString(charSize))



func _onRefresh():
	if not _isReady:
		return
	if get_child_count() != 1:
		print('n childs: (should be 1) ', get_child_count(), ' ', get_path())	
		return
	var child = get_children()[0]
	child.charPos = Vector2(1,1)
	
func getMinCharSize():
	return get_children()[0].getMinCharSize() + Vector2(2,2)


func setCharSize(sz):
	.setCharSize(sz)
	get_children()[0].setCharSize(sz-Vector2(2,2))


func setCharHeight(y):
	.setCharHeight(y)
	get_children()[0].setCharWidth(y-2)
	
func setCharWidth(x):
	.setCharWidth(x)
	get_children()[0].setCharWidth(x-2)
