extends Control


func _ready():
	connect("resized", TUI, "_onOlayResized")
	mouse_filter = MOUSE_FILTER_IGNORE
	TUI.setOverlay(self)


func _draw():
	print("TUI_Overlay._draw()")
	draw_rect(Rect2(Vector2(), rect_size), Color(0,0,0, .5))

	for linenum in range(TUI.nLines):
		var pos = Vector2(0, TUI.cHeight*(linenum+1))
		draw_string(TUI.font, pos, TUI.lines[linenum])
