extends Node


const  DRAW_DEBUG_PATTERN = false

var _overlay = null


var cWidth := 0
var cHeight := 0
var cSize : Vector2
var nCols := 0
var nLines := 0
var lines := []


# var _redrawNeeded = true

var font : Font = load("res://FixedSys24.tres")



func _ready():
	cWidth = font.get_string_size("aa").x - font.get_string_size("a").x
	cHeight = font.get_string_size("a").y
	cSize = Vector2(cWidth, cHeight)


func setOverlay(olay):
	_overlay = olay
	_onOlayResized()


func _onOlayResized():
	# print('onResized()')
	nCols = _overlay.rect_size.x / cWidth
	nLines = _overlay.rect_size.y / cHeight

	_clear()

	print('cWidth x cHeight: %sx%s, nCols x nLines: %sx%s' % [cWidth, cHeight, nCols, nLines])
	onNeedRedraw()


func _clear():	
	var fillChar = " "
	var ln = ""

	if DRAW_DEBUG_PATTERN:
		fillChar = "."

	lines = []

	for colnum in range(nCols):
		ln += fillChar

	if DRAW_DEBUG_PATTERN and ln.length() > 0:
		ln[0] = '<'
		ln[-1] = ">"

	for linenum in range(nLines):
		lines.append(ln)

	if DRAW_DEBUG_PATTERN and ln.length() > 0 and lines.size() > 0:
		lines[0][0] = "S"
		lines[-1][-1] = "E"
	

static func _childrenInDrawOrder(root):
	var drawOrder = []
	for child in root.get_children():
		drawOrder.append(child)
		drawOrder += _childrenInDrawOrder(child)
	return drawOrder
		

func _drawableElements():
	var tgts = []
	for child in _childrenInDrawOrder(get_tree().get_root()):
		if child.has_method("tuiDraw"):
			tgts.append(child)
	return tgts

func onNeedRedraw():
	# print('onNeedRedraw()')
	# _redrawNeeded = true
	set_process(true)
			

func _process(delta):
	# print("_process()")
	# if cWidth == 0:
	# 	return

	set_process(false)
	# _redrawNeeded = false
	
	_clear()

	# print("iterating children")
	for child in _drawableElements():
		child.tuiDraw(self)
	if _overlay != null:
		_overlay.update()


func registerElement(elem):
	elem.connect("draw", TUI, "onNeedRedraw") 
	elem.connect("visibility_changed", TUI, "onNeedRedraw") 

func drawToTUI(owner, string):
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



func boxString(size, text=""):
	var box_nCols = round(size.x as float / cWidth) as int
	var box_nLines = round(size.y as float/ cHeight) as int
	box_nCols = max(box_nCols, text.length() + 2)
	box_nLines = max(box_nLines, 3)


	var extraLines = box_nLines - 3
	var extraLines_bottom = extraLines / 2
	var extraLines_top = extraLines - extraLines_bottom


	var s = "┌"
	for colnum in range(1, box_nCols-1):
		s += "─"
	s += "┐\n"

	for i in range(extraLines_top):
		s += "│" + util.nSpaces(box_nCols-2) + "│\n"

	s += "│" + util.lrpad_chars(box_nCols-2, text) + "│\n"

	for i in range(extraLines_bottom):
		s += "│" + util.nSpaces(box_nCols-2) + "│\n"

	s += "└"
	for colnum in range(1, box_nCols-1):
		s += "─"
	s += "┘"
	return s
