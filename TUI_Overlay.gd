extends Label


const DEBUG_PRINT = false

var _visible = true

func _ready():
	connect("resized", TUI, "_onOlayResized")
	mouse_filter = MOUSE_FILTER_IGNORE
	# mouse_filter = MOUSE_FILTER_PASS
	TUI.setOverlay(self)



func _drawChar(var linenum, var colnum):
	var tl = Vector2(colnum, linenum) * TUI.cSize
	var bl = Vector2(colnum, linenum+1) * TUI.cSize
	
	if (linenum + colnum) % 2 == 0:
		draw_rect(Rect2(tl, TUI.cSize), Color(1, 0, 0, 0.06))
	draw_string(TUI.font, bl, TUI.lines[linenum][colnum], Color(0,1,0))

func _draw():
	if not _visible:
		return
	# print("TUI_Overlay._draw()")
	# draw_rect(Rect2(Vector2(), rect_size), Color(0,0,0, .8))

	for linenum in range(TUI.nLines):
		# var pos = Vector2(0, TUI.cHeight*(linenum+1))
		# draw_string(TUI.font, pos, TUI.lines[linenum])

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
		_visible = not _visible
		update()

		for child in TUI._childrenInDrawOrder(get_tree().get_root()):
			if child.has_method("debugPrint"):
				child.debugPrint()
