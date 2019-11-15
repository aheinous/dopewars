extends Label


const DEBUG_PRINT = false

enum DrawMode {BOTH, GUI_ONLY, TUI_ONLY}
var drawMode = DrawMode.BOTH

func _ready():
	connect("resized", TUI, "_onOlayResized")
	mouse_filter = MOUSE_FILTER_IGNORE
	# mouse_filter = MOUSE_FILTER_PASS
	TUI.setOverlay(self)



func _drawChar(var linenum, var colnum):
	var tl = Vector2(colnum, linenum) * TUI.cSize
	var bl = Vector2(colnum, linenum+1) * TUI.cSize
	
	if drawMode == DrawMode.BOTH and (linenum + colnum) % 2 == 0:
		draw_rect(Rect2(tl, TUI.cSize), Color(1, 0, 0, 0.06))
	draw_string(TUI.font, bl, TUI.dataGrid[linenum][colnum].c, Color(0,1,0))



func _draw():
	if drawMode == DrawMode.GUI_ONLY:
		return
	if drawMode == DrawMode.TUI_ONLY:
		draw_rect(Rect2(Vector2(), rect_size), Color(0,0,0))

	for linenum in range(TUI.nLines):

		for colnum in range(TUI.nCols):
			_drawChar(linenum, colnum)

		if DEBUG_PRINT:
			print(TUI.lines[linenum])


func _input(event):
	pass
	# print('event: ', event)
	# print(mouse_filter)
	# print(event.position, event.position / Vector2(TUI.cWidth, TUI.cHeight), Vector2(TUI.nCols, TUI.nLines))

func _process(delta):
	if Input.is_action_just_pressed("toggle_tui"):
		print("toggle tui")
		drawMode = (drawMode + 1) % DrawMode.size()
		update()

		for child in TUI._childrenInDrawOrder(get_tree().get_root()):
			if child.has_method("debugPrint"):
				child.debugPrint()
