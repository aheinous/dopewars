extends Button

func _ready():
	TUI.registerElement(self)
	set_custom_minimum_size(charSize() * TUI.cSize)
	print('button ready: %s' % text)

func tuiDraw(tui):
	# print("tuiDraw()")
	if not is_visible_in_tree():
		return 
	# var olay = tui_manager.overlay
	tui.drawToTUI(self, tui.boxString(rect_size, text))
	# print("%s rect size. ratio: %s, %s" % [text, rect_size, rect_size/TUI.cSize])


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
	

	
func charSize():
	return Vector2(text.length()+2, 3)


func _on_cancelButton_minimum_size_changed():
	print("minSizeChanged: ", self.text)