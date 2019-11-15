extends Button

func _ready():
	TUI.registerElement(self)
	print(Vector2(TUI.cWidth*(text.length()+2), TUI.cHeight*3))
	set_custom_minimum_size(Vector2(TUI.cWidth*(text.length()+2), TUI.cHeight*3))
	print('button ready: %s' % text)

func tuiDraw(tui):
	# print("tuiDraw()")
	if not is_visible_in_tree():
		return 
	# var olay = tui_manager.overlay
	tui.drawToTUI(self, tui.boxString(rect_size, text))


# static func roundUpToMult(x:int, mult:int):
# 	return ((x + mult - 1) / mult) * mult


# func get_minimum_size():
# 	var olay = tui_manager.overlay
# 	var minSize = rect_min_size
# 	minSize.x = max(minSize.x, olay.cWidth*3)
# 	minSize.y = max(minSize.y, olay.cHeight*3)

# 	minSize.x = roundUpToMult(minSize.x, olay.cWidth)
# 	minSize.y = roundUpToMult(minSize.y, olay.cHeight)

# 	print('get_minimum_size(): %s, %s, %s' % minSize, olay.cWidth, olay.cHeight )

# 	return minSize
	

	



func _on_cancelButton_minimum_size_changed():
	print("minSizeChanged: ", self.text)
