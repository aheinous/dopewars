extends "res://tui/tuiElement.gd"



func tuiDraw(tui):
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, tui.boxString(rect_size))

	
