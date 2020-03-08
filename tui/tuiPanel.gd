extends "res://tui/tuiElement.gd"

# func charSize():
# 	return rect_size / TUI.cSize


func tuiDraw(tui):
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, tui.boxString(rect_size))
	# print("tuiPanel rect size. ratio: %s, %s" % [ rect_size, rect_size/TUI.cSize])
	
