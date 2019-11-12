extends Node

var _overlay = null


var lines := []
var cWidth := 0
var cHeight := 0
var nCols := 0
var nLines := 0


var redrawNeeded = true

var font : Font = load("res://FixedSys24.tres")

func boxString(size, text):
	var box_nCols = round(size.x as float / cWidth) as int
	var box_nLines = round(size.y as float/ cHeight) as int
	box_nCols = max(box_nCols, text.length() + 2)
	box_nLines = max(box_nLines, 3)

	var s = "┌"
	for colnum in range(1, box_nCols-1):
		s += "─"
	s += "┐\n"

	s += "│" + util.lrpad_chars(box_nCols-2, text) + "│\n"

	s += "└"
	for colnum in range(1, box_nCols-1):
		s += "─"
	s += "┘"
	return s


func _drawTargets():
	var tgts = []
	for child in _childrenInDrawOrder(get_tree().get_root()):
		if child.has_method("tuiDraw"):
			tgts.append(child)
	return tgts

func _childrenInDrawOrder(root):
	var drawOrder = []
	for child in root.get_children():
		drawOrder.append(child)
		drawOrder += _childrenInDrawOrder(child)
	return drawOrder


func setOverlay(olay):
	_overlay = olay
	_onOlayResized()


func _onOlayResized():
	print('onResized()')

	cWidth = font.get_string_size("aa").x - font.get_string_size("a").x
	cHeight = font.get_string_size("a").y
	nCols = _overlay.rect_size.x / cWidth
	nLines = _overlay.rect_size.y / cHeight

	_clear()

	print('cWidth x cHeight: %sx%s, nCols x nLines: %sx%s' % [cWidth, cHeight, nCols, nLines])
	onNeedRedraw()


func _clear():
	var fillChar = " "
	var ln = ""

	lines = []

	for colnum in range(nCols):
		ln += fillChar

	for linenum in range(nLines):
		lines.append(ln)


func onNeedRedraw():
	print('onNeedRedraw()')
	redrawNeeded = true
	set_process(true)
			

func _process(delta):
	print("_process()")
	if cWidth == 0:
		return

	set_process(false)
	redrawNeeded = false
	
	_clear()

	print("iterating children")
	for child in _drawTargets():
		child.tuiDraw(self)
	_overlay.update()


func registerString(owner, string):
	var pos = owner.get_global_position()

	var startcol = round(pos.x as float / cWidth) as int
	var startline = round(pos.y as float / cHeight) as int

	var colnum = startcol
	var linenum = startline

	for c in string:
		if c == "\n":
			linenum += 1
			colnum = startcol
			continue
		if colnum >= nCols or linenum >= nLines:
			print("tui drawing offscreen")
			continue
		lines[linenum][colnum] = c
		colnum += 1