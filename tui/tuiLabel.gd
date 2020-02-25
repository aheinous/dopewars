extends Label


var maxCols

func setText(s, maxCols=null):
	if maxCols == null:
		maxCols = TUI.nCols - 2

	text = util.wordWrap(s, maxCols)
	rect_size = charSize() * TUI.cSize


func charSize():
	return util.getCharSize(self.text)


func tuiDraw(tui):
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, text)
