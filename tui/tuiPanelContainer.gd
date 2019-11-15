extends PanelContainer

func _ready():
	TUI.registerElement(self)
	# set_custom_minimum_size(Vector2(TUI.cWidth*2, TUI.cHeight*2))
	tuiRefreshMinSize()





func tuiDraw(tui):
	print("tuiPanelContainer.tuiDraw()")
	if not is_visible_in_tree():
		return 
	tui.drawToTUI(self, tui.boxString(rect_size))
	print("panel container rect size. ratio: %s, %s" % [rect_size, rect_size/TUI.cSize])
	for child in get_children():
		print("\tchild rect size. ratio: %s, %s" % [child.rect_size, child.rect_size/TUI.cSize])


func tuiRefreshMinSize():
	# var minSize = Vector2()
	# for child in get_children():
	# 	var childMinSize = child.get_minimum_size()
	# 	minSize.x = max(minSize.x, childMinSize.x)
	# 	minSize.y = max(minSize.y, childMinSize.y)
	# # minSize += (2 * TUI.cSize)
	# set_custom_minimum_size(minSize)
	pass
	set_custom_minimum_size(util.vec2_roundUpToMult(rect_size, TUI.cSize))
		




func _on_PanelContainer_draw():
	tuiRefreshMinSize()
	pass
