extends Control


const DEBUG_PRINT = false

var _lastMouseCCoords = null

func _ready():
	connect("resized", TUI, "_onOlayResized")
	mouse_filter = MOUSE_FILTER_STOP
	TUI.setOverlay(self)



func _drawChar(var linenum, var colnum):
	var tl = Vector2(colnum, linenum) * TUI.cSize
	var bl = Vector2(colnum, linenum+1) * TUI.cSize
	
	# if  (linenum + colnum) % 2 == 0:
	# 	draw_rect(Rect2(tl, TUI.cSize), Color(1, 1, 1, .1))
	draw_string(TUI.font, bl, TUI.dataGrid[linenum][colnum].c, TUI.dataGrid[linenum][colnum].fg)



func _draw():
	draw_rect(Rect2(Vector2(), rect_size), Color(0,0,0))

	for linenum in range(TUI.nLines):

		for colnum in range(TUI.nCols):
			_drawChar(linenum, colnum)

		if DEBUG_PRINT:
			print(TUI.lines[linenum])


func _input(event):
	if event is InputEventMouseMotion:
		var cCoords = TUI.pixelCoordsToCharCoords(event.position)
		if cCoords != _lastMouseCCoords:
			TUI._onMouseMove(cCoords)

	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		var cCoords = TUI.pixelCoordsToCharCoords(event.position)
		if event.pressed:
			TUI._onMousePress(cCoords)
		elif  not event.pressed:
			TUI._onMouseRelease(cCoords)



# func _process(delta):				
# 	if Input.is_action_just_pressed("refresh"):
# 		$"/root/Game".refresh()
