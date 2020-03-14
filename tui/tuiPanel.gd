extends "res://tui/tuiElement.gd"



func tuiDraw(tui):
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, tui.boxStringCS(charSize))



func _onRefresh():
	if not _isReady:
		return
	if get_child_count() != 1:
		print('n childs: (should be 1) ', get_child_count(), ' ', get_path())	
		return
	var child = get_children()[0]
	child.charPos = Vector2(1,1)
	
func getMinCharSize():
	return get_children()[0].charSize + Vector2(2,2)
