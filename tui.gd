extends Node

const Colors = {	
	"NORMAL":Color(0,1,0),
	"DISABLED" : Color(0.5, 0.5, 0.5),
	"NOT_ACTIVE":Color(0, .3, 0),
	"PRESSED":Color(1, 0, 0)
}

const  DRAW_DEBUG_PATTERN = false

var _overlay = null


var cWidth := 0
var cHeight := 0
var cSize : Vector2
var nCols := 0
var nLines := 0
var dataGrid := []


var font : Font = load("res://FixedSys24.tres")

var activeSubtree = null

var _lastPressOwner = null
var _mouseCCoordOwner = null


class CharData:
	var c : String = " "
	var owner = null
	var fg : Color
	var bg : Color
	var pressable : bool

	func _init(c = " ", owner=null, fg=Colors["NORMAL"], bg=Color(0,0,0), pressable=false):
		self.c = c
		self.owner = owner
		self.fg = fg
		self.bg = bg
		self.pressable = pressable


func _ready():
	cWidth = font.get_string_size("aa").x - font.get_string_size("a").x
	cHeight = font.get_string_size("a").y
	cSize = Vector2(cWidth, cHeight)


func setOverlay(olay):
	_overlay = olay
	_onOlayResized()


func pixelCoordsToCharCoords(pCoords):
	var cCoords = pCoords / cSize
	cCoords.x = cCoords.x as int
	cCoords.y = cCoords.y as int
	if cCoords.x >= nCols or cCoords.y >= nLines or cCoords.x < 0 or cCoords.y < 0:
		return null
	return cCoords


func _onOlayResized():
	nCols = _overlay.rect_size.x / cWidth
	nLines = _overlay.rect_size.y / cHeight
	_clear()
	onNeedRedraw()


func _clear():
	dataGrid = []
	for linenum in range(nLines):
		dataGrid.append([])
		for colnum in range(nCols):
			var fillChar = " "

			var lastLine = nLines-1
			var lastCol = nCols-1

			if DRAW_DEBUG_PATTERN:
				match [linenum, colnum]:
					[0,0]:
						fillChar = "S"
					[lastLine, lastCol]:
						fillChar = "E"
					[_,0]:
						fillChar = "<"
					[_,lastCol]:
						fillChar = ">"
					_:
						fillChar = "."

			dataGrid[-1].append(CharData.new(fillChar))
			

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


func _getCharOwner(cCoords):
	return null if cCoords == null else dataGrid[cCoords.y][cCoords.x].owner

func _isCoordPressable(cCoords):
	return false if cCoords == null else dataGrid[cCoords.y][cCoords.x].pressable


func _onMousePress(cCoords):
	if _isCoordPressable(cCoords):
		_lastPressOwner = _getCharOwner(cCoords)
	else:
		_lastPressOwner = null
	onNeedRedraw()

func _onMouseRelease(cCoords):
	# var owner = dataGrid[cCoords.y][cCoords.x].owner
	var owner = _getCharOwner(cCoords)
	if owner != null and owner == _lastPressOwner and _inActiveSubtree(owner):
		owner.emit_signal("pressed")
	_lastPressOwner = null
	onNeedRedraw()

func _onMouseMove(cCoords):
	# var owner = dataGrid[cCoords.y][cCoords.x].owner
	var owner = _getCharOwner(cCoords)
	if owner != _mouseCCoordOwner:
		_mouseCCoordOwner = owner
		onNeedRedraw()

func registerElement(elem):
	elem.connect("draw", TUI, "onNeedRedraw") 
	elem.connect("visibility_changed", TUI, "onNeedRedraw") 


func _inActiveSubtree(node):
	if activeSubtree == null:
		return true
	while true:
		if node == null:
			return false
		if node == activeSubtree:
			return true
		node = node.get_parent()

func _isDisabled(node):
	return node.has_method("is_disabled")  and node.is_disabled()


func _isPressable(node):
	if not _inActiveSubtree(node) or _isDisabled(node):
		return false

	for sig in node.get_signal_list():
		if sig.name == "pressed":
			return true

	return false


func drawToTUI(owner, string):
	if not owner.is_visible_in_tree():
		return 

	var pos = owner.get_global_position()

	var startcol = round(pos.x as float / cWidth) as int
	var startline = round(pos.y as float / cHeight) as int

	var colnum = startcol
	var linenum = startline

	_inActiveSubtree(owner)

	var color = Colors["NOT_ACTIVE"]
	if _inActiveSubtree(owner):
		color = Colors["NORMAL"]
	if owner == _lastPressOwner and owner == _mouseCCoordOwner:
		color = Colors["PRESSED"]
	if _isDisabled(owner):
		color = Colors["DISABLED"]

	# var pressable = owner.has_user_signal("pressed") and _inActiveSubtree(owner) and not _isDisabled(owner)
	# print("PRESSABLE:" , string, pressable, owner.has_user_signal("pressed"))
	# if string == "Okay":
	# 	print("...")

	var pressable = _isPressable(owner)

	# if owner.has_method("get_text"):
	# 	print("text, focus: %s, %s" % [owner.get_text(), owner.has_focus()])

	for c in string:
		if c == "\n":
			linenum += 1
			colnum = startcol
			continue
		if colnum >= nCols or linenum >= nLines:
			# print("tui drawing offscreen")
			continue
		dataGrid[linenum][colnum].c = c
		dataGrid[linenum][colnum].owner = owner
		dataGrid[linenum][colnum].fg = color
		dataGrid[linenum][colnum].pressable = pressable

		
		colnum += 1



func skinnyButtonStr(size, text=""):
	var box_nCols = round(size.x as float / cWidth) as int
	return "│" + util.lrpad_chars(box_nCols-2, text) + "│\n"

	

func centeredStr(size, text=""):
	var box_nCols = round(size.x as float / cWidth) as int
	return util.lrpad_chars(box_nCols, text) + "\n"

	


func boxString(size, text="", half=false):
	var box_nCols = round(size.x as float / cWidth) as int
	var box_nLines = round(size.y as float/ cHeight) as int
	box_nCols = max(box_nCols, text.length() + 2)
	box_nLines = max(box_nLines, 3)


	var extraLines = box_nLines - 3
	var extraLines_bottom = extraLines / 2
	var extraLines_top = extraLines - extraLines_bottom


	var s = "┌"
	for _colnum in range(1, box_nCols-1):
		s += "─"
	s += "┐\n"

	for _i in range(extraLines_top):
		s += "│" + util.nSpaces(box_nCols-2) + "│\n"

	s += "│" + util.lrpad_chars(box_nCols-2, text) + "│\n"

	for _i in range(extraLines_bottom):
		s += "│" + util.nSpaces(box_nCols-2) + "│\n"

	if half:
		return s.substr(0, s.length()-1)

	s += "└"
	for _colnum in range(1, box_nCols-1):
		s += "─"
	s += "┘"
	return s


func boxStringCS(size, text="", half=false):
		var box_nCols : int = size.x
		var box_nLines : int = size.y
		box_nCols = max(box_nCols, text.length() + 2)
		box_nLines = max(box_nLines, 3)
	
	
		var extraLines = box_nLines - 3
		var extraLines_bottom = extraLines / 2
		var extraLines_top = extraLines - extraLines_bottom
	
	
		var s = "┌"
		for _colnum in range(1, box_nCols-1):
			s += "─"
		s += "┐\n"
	
		for _i in range(extraLines_top):
			s += "│" + util.nSpaces(box_nCols-2) + "│\n"
	
		s += "│" + util.lrpad_chars(box_nCols-2, text) + "│\n"
	
		for _i in range(extraLines_bottom):
			s += "│" + util.nSpaces(box_nCols-2) + "│\n"
	
		if half:
			return s.substr(0, s.length()-1)
	
		s += "└"
		for _colnum in range(1, box_nCols-1):
			s += "─"
		s += "┘"
		return s
	
